import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/schedule.dart';
import '../utils/constants.dart';

class ScheduleProvider with ChangeNotifier {
  final Box<Schedule> _scheduleBox = Hive.box<Schedule>(AppConstants.scheduleBox);
  List<Schedule> _schedules = [];

  List<Schedule> get schedules => _schedules;
  List<Schedule> get todaySchedules => _schedules.where((s) => 
    s.dateTime.year == DateTime.now().year &&
    s.dateTime.month == DateTime.now().month &&
    s.dateTime.day == DateTime.now().day
  ).toList();

  ScheduleProvider() {
    loadSchedules();
  }

  void loadSchedules() {
    _schedules = _scheduleBox.values.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  Future<void> addSchedule(Schedule schedule) async {
    await _scheduleBox.put(schedule.id, schedule);
    loadSchedules();
  }

  Future<void> updateSchedule(Schedule schedule) async {
    await schedule.save();
    loadSchedules();
  }

  Future<void> deleteSchedule(String id) async {
    await _scheduleBox.delete(id);
    loadSchedules();
  }

  Future<void> toggleCompleted(String id) async {
    final schedule = _scheduleBox.get(id);
    if (schedule != null) {
      schedule.isCompleted = !schedule.isCompleted;
      await schedule.save();
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
}