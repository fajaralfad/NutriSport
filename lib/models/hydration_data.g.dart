// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hydration_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HydrationDataAdapter extends TypeAdapter<HydrationData> {
  @override
  final int typeId = 2;

  @override
  HydrationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HydrationData(
      weight: fields[0] as double,
      exerciseDuration: fields[1] as double,
      intensity: fields[2] as String,
      recommendedWater: fields[3] as double,
      consumedWater: fields[4] as double,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HydrationData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.exerciseDuration)
      ..writeByte(2)
      ..write(obj.intensity)
      ..writeByte(3)
      ..write(obj.recommendedWater)
      ..writeByte(4)
      ..write(obj.consumedWater)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HydrationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
