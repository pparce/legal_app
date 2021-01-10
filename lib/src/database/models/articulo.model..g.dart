// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articulo.model..dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticuloAdapter extends TypeAdapter<Articulo> {
  @override
  final int typeId = 0;

  @override
  Articulo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Articulo(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Articulo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.tipo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticuloAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
