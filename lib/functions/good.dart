import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/functions/grade_button_action.dart';
import 'package:time/time.dart';

class Good implements GradeButtonAction {
  @override
  void graduated(Flashcard card) {
    card.currentInterval = (card.currentInterval *
        card.easeFactor! *
        card.parentDeck!.intervalModifier *
        0.0001);
  }

  @override
  void lapsed(Flashcard card) {
    // Lapsed
    card.stepIndex++;
    if (card.parentDeck!.stepsLapse!.length != card.stepIndex) {
      // Card that as not yet completed all its steps
      card.currentInterval = card.parentDeck!.stepsLapse![card.stepIndex];
    } else {
      // Card that as completed all its steps
      card.stepIndex = 0;
      card.cardState = 1;
      card.currentInterval *= card.parentDeck!.newIntervalPercent! * 0.01;
      if (card.currentInterval <= card.parentDeck!.minInterval!) {
        card.currentInterval = card.parentDeck!.minInterval!;
      }
    }
  }

  @override
  void newCard(Flashcard card) {
    if (card.parentDeck!.stepsLearning!.length != card.stepIndex) {
      // Card that as not yet completed all its steps

      card.currentInterval = card.parentDeck!.stepsLearning![card.stepIndex];
    } else {
      // Card that as completed all its steps
      card.stepIndex = 0;
      card.cardState = 1;
      card.currentInterval = 1.days;
    }
    card.stepIndex++;
  }
}
