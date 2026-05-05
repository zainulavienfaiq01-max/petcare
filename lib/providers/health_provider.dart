import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/health_record.dart';
import '../utils/constants.dart';

class HealthProvider with ChangeNotifier {
  final Box<HealthRecord> _healthBox = Hive.box<HealthRecord>(AppConstants.healthBox);
  List<HealthRecord> _records = [];

  List<HealthRecord> get records => _records;

  HealthProvider() {
    loadRecords();
  }

  void loadRecords() {
    _records = _healthBox.values.toList()..sort((a, b) => b.checkupDate.compareTo(a.checkupDate));
    notifyListeners();
  }

  Future<void> addRecord(HealthRecord record) async {
    await _healthBox.put(record.id, record);
    loadRecords();
  }

  Future<void> updateRecord(HealthRecord record) async {
    await record.save();
    loadRecords();
  }

  Future<void> deleteRecord(String id) async {
    await _healthBox.delete(id);
    loadRecords();
  }

  List<HealthRecord> getRecordsByPet(String petId) {
    return _records.where((r) => r.petId == petId).toList();
  }
}