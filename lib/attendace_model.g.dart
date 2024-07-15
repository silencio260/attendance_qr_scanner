// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendace_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendaceAdapter extends TypeAdapter<Attendace> {
  @override
  final int typeId = 1;

  @override
  Attendace read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attendace(
      name: fields[0] as String,
      attendace: (fields[1] as List)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Attendace obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.attendace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
