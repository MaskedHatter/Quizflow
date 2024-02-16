// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardAdapter extends TypeAdapter<Flashcard> {
  @override
  final int typeId = 0;

  @override
  Flashcard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flashcard(
      questionText: fields[0] as String?,
      questionAnswer: fields[1] as String?,
    )
      ..parentDeck = fields[2] as Carddeck?
      ..cardFrontComponents = (fields[3] as List).cast<String>()
      ..cardBackcomponents = (fields[4] as List).cast<String>()
      ..cardState = fields[5] as int
      ..stepIndex = fields[6] as int
      ..easeFactor = fields[7] as int?
      ..currentInterval = fields[8] as Duration
      ..lastDate = fields[9] as DateTime?
      ..scheduleDate = fields[10] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Flashcard obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.questionText)
      ..writeByte(1)
      ..write(obj.questionAnswer)
      ..writeByte(2)
      ..write(obj.parentDeck)
      ..writeByte(3)
      ..write(obj.cardFrontComponents)
      ..writeByte(4)
      ..write(obj.cardBackcomponents)
      ..writeByte(5)
      ..write(obj.cardState)
      ..writeByte(6)
      ..write(obj.stepIndex)
      ..writeByte(7)
      ..write(obj.easeFactor)
      ..writeByte(8)
      ..write(obj.currentInterval)
      ..writeByte(9)
      ..write(obj.lastDate)
      ..writeByte(10)
      ..write(obj.scheduleDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
