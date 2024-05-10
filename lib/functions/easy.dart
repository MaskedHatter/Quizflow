import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/functions/grade_button_action.dart';
import 'package:quizflow/viewmodel/settings_model.dart';

class Easy implements GradeButtonAction {
  @override
  void graduated(Flashcard card) {
    // Card is graduated
    // Increase ease factor
    card.currentInterval = (card.currentInterval *
        card.easeFactor! *
        card.parentDeck!.intervalModifier *
        SettingsModel.easyBonus *
        0.0001);
    card.stepIndex = 0;
    card.easeFactor = card.easeFactor! + 15;
  }

  @override
  void lapsed(Flashcard card) {
    // Lapsed
    card.stepIndex++;
    if (card.parentDeck!.stepsLapse!.length != card.stepIndex) {
      // Card that as not yet completed all its steps
      card.currentInterval = card.parentDeck!.stepsLapse![card.stepIndex] * 2;
    } else {
      // Card that as completed all its steps
      card.stepIndex = 0;
      card.cardState = 1;
      card.currentInterval *= card.parentDeck!.newIntervalPercent! * 0.01 * 2;
    }
  }

  @override
  void newCard(Flashcard card) {
    // Card is new
    // Card graduates
    card.cardState = 1;
    card.currentInterval = SettingsModel.easyInterval;
  }
}
