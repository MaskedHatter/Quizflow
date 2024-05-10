import 'dart:math' as math;

import 'package:hive/hive.dart';
import 'package:quizflow/collection_types/card_deck_register.dart';
import 'package:quizflow/collection_types/collection.dart';
import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/collection_types/folder.dart';
import 'package:quizflow/viewmodel/hive_model.dart';
import 'package:quizflow/viewmodel/settings_model.dart';

part 'card_deck.g.dart';

@HiveType(typeId: 1)
class Carddeck extends CollectionTypes {
  @HiveField(0)
  String title;

  @HiveField(1)
  double folderLevel;

  @HiveField(2)
  Folder? parent;

  @HiveField(3)
  HiveList<CollectionTypes>? flashcards;

  @HiveField(4)
  List<CollectionTypes> flashcardsRaw;

  @HiveField(5)
  List<String> pathList;

  @HiveField(6)
  int noOfQuestionsCorrect = 0;

  @HiveField(7)
  int noOfQuestionsWrong = 0;

  @HiveField(8)
  int noOfQuestions = 0;

  @HiveField(9)
  int lastIndexReached = 0;

  // New Card
  @HiveField(10)
  List<Duration>? stepsLearning;

  @HiveField(11)
  int? newCardsAday;

  @HiveField(12)
  Duration? graduatingInterval;

  @HiveField(13)
  Duration? easyInterval;

  @HiveField(14)
  int? startingEase;

  // Lapse
  @HiveField(15)
  List<Duration>? stepsLapse;

  @HiveField(16)
  int? newIntervalPercent;

  @HiveField(17)
  Duration? minInterval;

  @HiveField(18)
  int? leechThreshold;

  @HiveField(19)
  double intervalModifier;

  @HiveField(20)
  String? boxId;

  Carddeck({
    required this.title,
    required this.folderLevel,
    required this.flashcardsRaw,
    required this.pathList,
    required this.parent,
    required this.intervalModifier,
  }) : super() {
    CarddeckRegister.updateReg(this);

    // New Card
    stepsLearning = SettingsModel.stepsLearning;
    newCardsAday = SettingsModel.newCardsAday;
    graduatingInterval = SettingsModel.graduatingInterval;
    easyInterval = SettingsModel.easyInterval;
    startingEase = SettingsModel.startingEase;

    //  Lapse Card
    stepsLapse = SettingsModel.stepsLapse;
    newIntervalPercent = SettingsModel.newIntervalPercent;
    minInterval = SettingsModel.minInterval;
    leechThreshold = SettingsModel.leechThreshold;

    intervalModifier = SettingsModel.intervalModifier;

    if (flashcards != null) {
      for (CollectionTypes card in flashcards!) {
        if (card is Flashcard) {
          card.parentDeck = this;
        }
      }
    }

    boxId = generateRandomString();

    ///setUpBox(flashcards!);
  }

  void addCard(Flashcard item) async {
    item.parentDeck = this;
    noOfQuestions++;
    Box box = await HiveControl.openBox(boxId!);
    await box.add(item);
    flashcards!.add(item);
    save();
  }

  void correct() {
    noOfQuestionsCorrect++;
  }

  void wrong() {
    noOfQuestionsWrong++;
  }

  int getNoOfQuestions() {
    noOfQuestions = flashcards!.length;
    return noOfQuestions;
  }

  String generateRandomString() {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    math.Random random = math.Random.secure();

    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
