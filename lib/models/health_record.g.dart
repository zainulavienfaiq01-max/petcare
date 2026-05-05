// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthRecordAdapter extends TypeAdapter<HealthRecord> {
  @override
  final int typeId = 2;

  @override
  HealthRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthRecord(
      id: fields[0] as String,
      petId: fields[1] as String,
      diseaseHistory: fields[2] as String,
      medication: fields[3] as String,
      allergies: fields[4] as String,
      checkupDate: fields[5] as DateTime,
      notes: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.petId)
      ..writeByte(2)
      ..write(obj.diseaseHistory)
      ..writeByte(3)
      ..write(obj.medication)
      ..writeByte(4)
      ..write(obj.allergies)
      ..writeByte(5)
      ..write(obj.checkupDate)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
