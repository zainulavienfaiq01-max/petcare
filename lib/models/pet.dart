import 'package:hive/hive.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type;

  @HiveField(3)
  int age;

  @HiveField(4)
  double weight;

  @HiveField(5)
  String? photoPath;

  // Feeding time stored as minutes since midnight (e.g. 480 = 08:00)
  @HiveField(6)
  int? feedingTimeMinutes;

  @HiveField(7)
  DateTime? vaccinationDate;

  @HiveField(8)
  int? groomingIntervalDays;

  @HiveField(9)
  DateTime? doctorCheckDate;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.weight,
    this.photoPath,
    this.feedingTimeMinutes,
    this.vaccinationDate,
    this.groomingIntervalDays,
    this.doctorCheckDate,
  });

  /// Helper to get feeding hour
  int get feedingHour => (feedingTimeMinutes ?? 480) ~/ 60;

  /// Helper to get feeding minute
  int get feedingMinute => (feedingTimeMinutes ?? 0) % 60;
}