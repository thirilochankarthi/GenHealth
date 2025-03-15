// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthDataAdapter extends TypeAdapter<HealthData> {
  @override
  final int typeId = 0;

  @override
  HealthData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthData(
      metric: fields[0] as String,
      value: fields[1] as double,
      timestamp: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.metric)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
