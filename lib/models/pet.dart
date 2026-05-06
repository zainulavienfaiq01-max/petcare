import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

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

  // New fields
  @HiveField(6)
  TimeOfDay? feedingTime;

  @HiveField(7)
  DateTime? vaccinationDate;

  @HiveField(8)
  int? groomingIntervalDays; // interval in days

  @HiveField(9)
  DateTime? doctorCheckDate;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.weight,
    this.photoPath,
    this.feedingTime,
    this.vaccinationDate,
    this.groomingIntervalDays,
    this.doctorCheckDate,
  });
}