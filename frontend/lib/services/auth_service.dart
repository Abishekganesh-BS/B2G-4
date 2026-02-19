import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider =
    StateNotifierProvider<AuthService, AuthState>((ref) => AuthService());

class AuthState {
  final String? token;
  final String? fullName;
  final bool isOnboarded;
  final bool isLoading;

  const AuthState({
    this.token,
    this.fullName,
    this.isOnboarded = false,
    this.isLoading = false,
  });

  bool get isLoggedIn => token != null;

  AuthState copyWith({
    String? token,
    String? fullName,
    bool? isOnboarded,
    bool? isLoading,
  }) {
    return AuthState(
      token: token ?? this.token,
      fullName: fullName ?? this.fullName,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthService extends StateNotifier<AuthState> {
  AuthService() : super(const AuthState());

  // Use 10.0.2.2 for Android emulator, 127.0.0.1 for everything else
  static String get _baseUrl {
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://127.0.0.1:8000/api/v1';
  }

  Dio get _dio {
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    // Debug interceptor
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint('[DIO] $obj'),
    ));
    return dio;
  }

  Dio get authenticatedDio {
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (state.token != null) 'Authorization': 'Bearer ${state.token}',
      },
    ));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint('[DIO] $obj'),
    ));
    return dio;
  }

  Future<void> login(String email, String password) async {
    debugPrint(
        '[AUTH DEBUG] login() called with email=$email, baseUrl=$_baseUrl');
    state = state.copyWith(isLoading: true);
    try {
      final response = await _dio.post('/auth/login',
          data: {
            'username': email,
            'password': password,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));

      debugPrint(
          '[AUTH DEBUG] Login response: ${response.statusCode} ${response.data}');
      state = AuthState(
        token: response.data['access_token'],
        fullName: response.data['full_name'],
        isOnboarded: response.data['is_onboarded'] ?? false,
        isLoading: false,
      );
      debugPrint(
          '[AUTH DEBUG] Auth state updated: isLoggedIn=${state.isLoggedIn}, isOnboarded=${state.isOnboarded}');
    } catch (e) {
      debugPrint('[AUTH DEBUG] Login error: $e');
      if (e is DioException) {
        debugPrint('[AUTH DEBUG] DioException type: ${e.type}');
        debugPrint(
            '[AUTH DEBUG] DioException response: ${e.response?.statusCode} ${e.response?.data}');
      }
      state = state.copyWith(isLoading: false);
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> register(String email, String password, String fullName) async {
    debugPrint(
        '[AUTH DEBUG] register() called with email=$email, name=$fullName, baseUrl=$_baseUrl');
    state = state.copyWith(isLoading: true);
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': fullName,
      });
      debugPrint(
          '[AUTH DEBUG] Register response: ${response.statusCode} ${response.data}');
      state = AuthState(
        token: response.data['access_token'],
        fullName: response.data['full_name'] ?? fullName,
        isOnboarded: response.data['is_onboarded'] ?? false,
        isLoading: false,
      );
      debugPrint(
          '[AUTH DEBUG] Auth state updated: isLoggedIn=${state.isLoggedIn}, isOnboarded=${state.isOnboarded}');
    } catch (e) {
      debugPrint('[AUTH DEBUG] Register error: $e');
      if (e is DioException) {
        debugPrint('[AUTH DEBUG] DioException type: ${e.type}');
        debugPrint(
            '[AUTH DEBUG] DioException response: ${e.response?.statusCode} ${e.response?.data}');
      }
      state = state.copyWith(isLoading: false);
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  void markOnboarded() {
    state = state.copyWith(isOnboarded: true);
  }

  void logout() {
    state = const AuthState();
  }
}
