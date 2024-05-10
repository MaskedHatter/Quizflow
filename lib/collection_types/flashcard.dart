import 'package:hive/hive.dart';
import 'package:quizflow/collection_types/card_deck.dart';
import 'package:quizflow/collection_types/collection.dart';
import 'package:quizflow/viewmodel/settings_model.dart';
import 'package:time/time.dart';
part 'flashcard.g.dart';
part 'duration.g.dart';

@HiveType(typeId: 0)
class Flashcard extends CollectionTypes {
  @HiveField(0)
  String? questionText = "";

  @HiveField(1)
  String? questionAnswer = "";

  @HiveField(2)
  Carddeck? parentDeck;

  @HiveField(3)
  List<String> cardFrontComponents = [];

  @HiveField(4)
  List<String> cardBackcomponents = [];

  // Algorithm data
  // 0 is new card
  // 1 is graduated card
  // 2 is relapsed card

  @HiveField(5)
  int cardState = 0;

  @HiveField(6)
  int stepIndex = 0;

  @HiveField(7)
  int? easeFactor = SettingsModel.startingEase;

  @HiveField(8)
  Duration currentInterval = 0.days;

  @HiveField(9)
  DateTime? lastDate;

  @HiveField(10)
  DateTime? scheduleDate;

  Flashcard({required this.questionText, required this.questionAnswer})
      : super() {
    cardFrontComponents = cardStructure(questionText!);
    cardBackcomponents = cardStructure(questionAnswer!);

    easeFactor = SettingsModel.startingEase;
  }

  List<String> cardStructure(String text) {
    List<String> structure =
        text.replaceAll("\n\n", "").split(RegExp('&\\|>|<\\|&'));
    structure.removeWhere((text) => text == "" || text == "\n");
    List<String> processedStruct = structure.map((item) {
      if (item.contains("img src=")) {
        String path = item.replaceFirst("img src=", "").replaceAll('"', "");
        return "</img/>$path";
      } else {
        return item;
      }
    }).toList();
    return processedStruct;
  }

  void setTimer() {
    lastDate = DateTime.now();
    scheduleDate = lastDate! + currentInterval;
  }
}
