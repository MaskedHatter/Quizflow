import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/functions/grade_button_action.dart';

class Again implements GradeButtonAction {
  void graduated(Flashcard card) {
    // Card that is graduated
    // Reduce ease factor
    card.currentInterval = card.parentDeck!.stepsLapse![card.stepIndex];
    card.stepIndex = 0;
    card.cardState = 2;
    card.easeFactor = card.easeFactor! - 20;
  }

  void lapsed(Flashcard card) {
    card.currentInterval = card.parentDeck!.stepsLapse![card.stepIndex];
    card.stepIndex = 0;
  }

  void newCard(Flashcard card) {
    // Card that is new
    // Start over steps
    card.currentInterval = card.parentDeck!.stepsLearning![card.stepIndex];
    card.stepIndex = 0;
  }
}
