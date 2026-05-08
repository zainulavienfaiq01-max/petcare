import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    // Local notifications are not supported on web.
    // On mobile, you would initialize flutter_local_notifications here.
    if (kIsWeb) {
      debugPrint('NotificationService: Running on web, notifications disabled.');
      return;
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (kIsWeb) {
      debugPrint('NotificationService: Would schedule "$title" at $scheduledTime');
      return;
    }
    // On mobile, use flutter_local_notifications with timezone scheduling
  }

  Future<void> cancelNotification(int id) async {
    if (kIsWeb) return;
    // On mobile, cancel via flutter_local_notifications
  }

  Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
  }
}