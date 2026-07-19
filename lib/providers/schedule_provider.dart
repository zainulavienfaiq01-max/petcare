import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/schedule.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';

class ScheduleProvider with ChangeNotifier {
  final Box<Schedule> _scheduleBox = Hive.box<Schedule>(AppConstants.scheduleBox);
  final NotificationService _notificationService = NotificationService();
  List<Schedule> _schedules = [];

  List<Schedule> get schedules => _schedules;
  List<Schedule> get todaySchedules => _schedules.where((s) => 
    s.dateTime.year == DateTime.now().year &&
    s.dateTime.month == DateTime.now().month &&
    s.dateTime.day == DateTime.now().day
  ).toList();

  List<Schedule> get tomorrowSchedules {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return _schedules.where((s) =>
      s.dateTime.year == tomorrow.year &&
      s.dateTime.month == tomorrow.month &&
      s.dateTime.day == tomorrow.day
    ).toList();
  }

  List<Schedule> get completedSchedules =>
      _schedules.where((s) => s.isCompleted).toList();

  List<Schedule> get overdueSchedules {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return _schedules.where((s) =>
      s.dateTime.isBefore(todayStart) && !s.isCompleted
    ).toList();
  }

  ScheduleProvider() {
    loadSchedules();
  }

  void loadSchedules() {
    _schedules = _scheduleBox.values.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  Future<void> addSchedule(Schedule schedule) async {
    await _scheduleBox.put(schedule.id, schedule);

    // Schedule a mobile notification reminder
    _scheduleNotificationForSchedule(schedule);

    loadSchedules();
  }

  Future<void> updateSchedule(Schedule schedule) async {
    await schedule.save();

    // Cancel old and reschedule notification
    await _notificationService.cancelNotification(schedule.id.hashCode);
    if (!schedule.isCompleted) {
      _scheduleNotificationForSchedule(schedule);
    }

    loadSchedules();
  }

  Future<void> deleteSchedule(String id) async {
    await _notificationService.cancelNotification(id.hashCode);
    await _scheduleBox.delete(id);
    loadSchedules();
  }

  Future<void> toggleCompleted(String id) async {
    final schedule = _scheduleBox.get(id);
    if (schedule != null) {
      schedule.isCompleted = !schedule.isCompleted;
      await schedule.save();

      if (schedule.isCompleted) {
        // Cancel notification when completed
        await _notificationService.cancelNotification(id.hashCode);
      } else {
        // Reschedule notification when uncompleted
        _scheduleNotificationForSchedule(schedule);
      }

      loadSchedules();
    }
  }

  List<Schedule> getSchedulesByPet(String petId) {
    return _schedules.where((s) => s.petId == petId).toList();
  }

  List<Schedule> getSchedulesByDate(DateTime date) {
    return _schedules.where((s) => 
      s.dateTime.year == date.year &&
      s.dateTime.month == date.month &&
      s.dateTime.day == date.day
    ).toList();
  }

  /// Schedule a mobile notification 15 minutes before the event.
  void _scheduleNotificationForSchedule(Schedule schedule) {
    if (schedule.isCompleted) return;

    final reminderTime = schedule.dateTime;
    if (reminderTime.isBefore(DateTime.now())) return;

    final emoji = AppConstants.scheduleTypeEmoji[schedule.type] ?? '📅';

    _notificationService.scheduleNotification(
      id: schedule.id.hashCode,
      title: '$emoji ${schedule.type} Reminder',
      body: 'you have a ${schedule.type.toLowerCase()} at ${schedule.dateTime.hour}:${schedule.dateTime.minute}!',
      scheduledTime: reminderTime,
      payload: schedule.id,
    );
  }
}