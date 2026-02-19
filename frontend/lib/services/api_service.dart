import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authNotifier = ref.read(authServiceProvider.notifier);
  return ApiService(authNotifier.authenticatedDio);
});

class MetricData {
  final int id;
  final String metricType;
  final double value;
  final String unit;
  final DateTime timestamp;

  MetricData({
    required this.id,
    required this.metricType,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  factory MetricData.fromJson(Map<String, dynamic> json) {
    return MetricData(
      id: json['id'],
      metricType: json['metric_type'],
      value: (json['value'] as num).toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class TeleSessionData {
  final int id;
  final String title;
  final DateTime scheduledAt;
  final String? notes;

  TeleSessionData({
    required this.id,
    required this.title,
    required this.scheduledAt,
    this.notes,
  });

  factory TeleSessionData.fromJson(Map<String, dynamic> json) {
    return TeleSessionData(
      id: json['id'],
      title: json['title'],
      scheduledAt: DateTime.parse(json['scheduled_at']),
      notes: json['notes'],
    );
  }
}

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // --- Onboarding ---
  Future<void> submitOnboarding({
    required int age,
    double? prePregnancyWeight,
    DateTime? lmpDate,
    String? conditions,
  }) async {
    await _dio.put('/users/onboard', data: {
      'age': age,
      'pre_pregnancy_weight': prePregnancyWeight,
      'lmp_date': lmpDate?.toIso8601String(),
      'conditions': conditions,
    });
  }

  // --- Metrics ---
  Future<List<MetricData>> getMetricHistory(String type,
      {int days = 30}) async {
    final response = await _dio.get('/metrics/history',
        queryParameters: {'metric_type': type, 'days': days});
    return (response.data as List).map((e) => MetricData.fromJson(e)).toList();
  }

  Future<void> createMetric(String type, double value, String unit) async {
    await _dio.post('/metrics/', data: {
      'metric_type': type,
      'value': value,
      'unit': unit,
    });
  }

  // --- Sessions ---
  Future<List<TeleSessionData>> getUpcomingSessions() async {
    final response = await _dio.get('/sessions/');
    return (response.data as List)
        .map((e) => TeleSessionData.fromJson(e))
        .toList();
  }

  Future<List<TeleSessionData>> getSessionReminders() async {
    final response = await _dio.get('/sessions/reminders');
    return (response.data as List)
        .map((e) => TeleSessionData.fromJson(e))
        .toList();
  }

  Future<void> createSession(String title, DateTime scheduledAt,
      {String? notes}) async {
    await _dio.post('/sessions/', data: {
      'title': title,
      'scheduled_at': scheduledAt.toIso8601String(),
      'notes': notes,
    });
  }
}
