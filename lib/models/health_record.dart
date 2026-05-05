import 'package:hive/hive.dart';

part 'health_record.g.dart';

@HiveType(typeId: 2)
class HealthRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String petId;

  @HiveField(2)
  String diseaseHistory;

  @HiveField(3)
  String medication;

  @HiveField(4)
  String allergies;

  @HiveField(5)
  DateTime checkupDate;

  @HiveField(6)
  String notes;

  HealthRecord({
    required this.id,
    required this.petId,
    this.diseaseHistory = '',
    this.medication = '',
    this.allergies = '',
    required this.checkupDate,
    this.notes = '',
  });
}