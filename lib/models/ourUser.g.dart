// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ourUser.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OurUserDetailOriginal extends TypeAdapter<OurUser> {
  @override
  final int typeId = 123;

  @override
  OurUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OurUser(
      approved: fields[4] as String?,
      email: fields[2] as String?,
      isCustomer: fields[1] as bool?,
      name: fields[3] as String?,
      uid: fields[0] as String?,
      interests: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OurUser obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.isCustomer)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.approved)
      ..writeByte(5)
      ..write(obj.interests);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OurUserDetailOriginal &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
