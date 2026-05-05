import 'package:hive/hive.dart';

part 'schedule.g.dart';

@HiveType(typeId: 1)
class Schedule extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String petId;

  @HiveField(2)
  String type;

  @HiveField(3)
  DateTime dateTime;

  @HiveField(4)
  String notes;

  @HiveField(5)
  bool isCompleted;

  Schedule({
    required this.id,
    required this.petId,
    required this.type,
    required this.dateTime,
    this.notes = '',
    this.isCompleted = false,
  });
}