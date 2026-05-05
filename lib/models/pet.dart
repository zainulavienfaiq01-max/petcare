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

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.weight,
    this.photoPath,
  });
}