// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NutritionDataAdapter extends TypeAdapter<NutritionData> {
  @override
  final int typeId = 1;

  @override
  NutritionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutritionData(
      bmr: fields[0] as double,
      tdee: fields[1] as double,
      protein: fields[2] as double,
      carbs: fields[3] as double,
      fat: fields[4] as double,
      calories: fields[5] as double,
      calculatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NutritionData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.bmr)
      ..writeByte(1)
      ..write(obj.tdee)
      ..writeByte(2)
      ..write(obj.protein)
      ..writeByte(3)
      ..write(obj.carbs)
      ..writeByte(4)
      ..write(obj.fat)
      ..writeByte(5)
      ..write(obj.calories)
      ..writeByte(6)
      ..write(obj.calculatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
