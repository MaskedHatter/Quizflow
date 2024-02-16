// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_deck.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarddeckAdapter extends TypeAdapter<Carddeck> {
  @override
  final int typeId = 1;

  @override
  Carddeck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Carddeck(
      title: fields[0] as String,
      folderLevel: fields[1] as double,
      flashcardsRaw: (fields[4] as List).cast<CollectionTypes>(),
      pathList: (fields[5] as List).cast<String>(),
      parent: fields[2] as Folder?,
      intervalModifier: fields[19] as double,
    )
      ..flashcards = (fields[3] as HiveList?)?.castHiveList()
      ..noOfQuestionsCorrect = fields[6] as int
      ..noOfQuestionsWrong = fields[7] as int
      ..noOfQuestions = fields[8] as int
      ..lastIndexReached = fields[9] as int
      ..stepsLearning = (fields[10] as List?)?.cast<Duration>()
      ..newCardsAday = fields[11] as int?
      ..graduatingInterval = fields[12] as Duration?
      ..easyInterval = fields[13] as Duration?
      ..startingEase = fields[14] as int?
      ..stepsLapse = (fields[15] as List?)?.cast<Duration>()
      ..newIntervalPercent = fields[16] as int?
      ..minInterval = fields[17] as Duration?
      ..leechThreshold = fields[18] as int?
      ..boxId = fields[20] as String?;
  }

  @override
  void write(BinaryWriter writer, Carddeck obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.folderLevel)
      ..writeByte(2)
      ..write(obj.parent)
      ..writeByte(3)
      ..write(obj.flashcards)
      ..writeByte(4)
      ..write(obj.flashcardsRaw)
      ..writeByte(5)
      ..write(obj.pathList)
      ..writeByte(6)
      ..write(obj.noOfQuestionsCorrect)
      ..writeByte(7)
      ..write(obj.noOfQuestionsWrong)
      ..writeByte(8)
      ..write(obj.noOfQuestions)
      ..writeByte(9)
      ..write(obj.lastIndexReached)
      ..writeByte(10)
      ..write(obj.stepsLearning)
      ..writeByte(11)
      ..write(obj.newCardsAday)
      ..writeByte(12)
      ..write(obj.graduatingInterval)
      ..writeByte(13)
      ..write(obj.easyInterval)
      ..writeByte(14)
      ..write(obj.startingEase)
      ..writeByte(15)
      ..write(obj.stepsLapse)
      ..writeByte(16)
      ..write(obj.newIntervalPercent)
      ..writeByte(17)
      ..write(obj.minInterval)
      ..writeByte(18)
      ..write(obj.leechThreshold)
      ..writeByte(19)
      ..write(obj.intervalModifier)
      ..writeByte(20)
      ..write(obj.boxId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarddeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
