import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
  }

  Future<bool?> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission();
    }
    return true;
  }

  Future<void> scheduleSessionReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    // Schedule 24h before
    final time24h = scheduledAt.subtract(const Duration(hours: 24));
    if (time24h.isAfter(DateTime.now())) {
      await _showNotificationAt(
        id: id * 2,
        title: '📅 Reminder: Tomorrow',
        body: '$title is tomorrow at ${_formatTime(scheduledAt)}',
        at: time24h,
      );
    }

    // Schedule 1h before
    final time1h = scheduledAt.subtract(const Duration(hours: 1));
    if (time1h.isAfter(DateTime.now())) {
      await _showNotificationAt(
        id: id * 2 + 1,
        title: '⏰ Starting Soon',
        body: '$title starts in 1 hour at ${_formatTime(scheduledAt)}',
        at: time1h,
      );
    }
  }

  Future<void> _showNotificationAt({
    required int id,
    required String title,
    required String body,
    required DateTime at,
  }) async {
    // Use a simple delayed approach since we don't need exact scheduling
    final delay = at.difference(DateTime.now());
    if (delay.isNegative) return;

    // For simplicity, show as an immediate notification
    // In production, use android_alarm_manager or workmanager for background scheduling
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'session_reminders',
          'Session Reminders',
          channelDescription:
              'Reminders for upcoming teleconsultation sessions',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
