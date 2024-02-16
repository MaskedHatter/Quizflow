part of 'flashcard.dart';

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final typeId = 100; // Choose a unique typeId for Duration

  @override
  Duration read(BinaryReader reader) {
    final seconds = reader.readInt();
    return Duration(seconds: seconds);
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inSeconds);
  }
}
