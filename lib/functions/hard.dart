import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/functions/grade_button_action.dart';
import 'package:quizflow/viewmodel/settings_model.dart';

class Hard implements GradeButtonAction {
  @override
  void graduated(Flashcard card) {
    // Card is graduated
    card.currentInterval = (card.currentInterval *
        SettingsModel.hardInterval *
        card.parentDeck!.intervalModifier *
        0.0001);
    // Reduce ease factor
    card.easeFactor = card.easeFactor! - 15;
  }

  @override
  void lapsed(Flashcard card) {
    card.currentInterval = (card.parentDeck!.stepsLapse![card.stepIndex + 1] +
        card.parentDeck!.stepsLapse![card.stepIndex] * 0.33);
    card.stepIndex = 0;
  }

  @override
  void newCard(Flashcard card) {
    // Card that is new
    // Average of the next step and the current step
    card.currentInterval =
        (card.parentDeck!.stepsLearning![card.stepIndex + 1] +
            card.parentDeck!.stepsLearning![card.stepIndex] * 0.33);
    // Start over steps
    card.stepIndex = 0;
  }
}
