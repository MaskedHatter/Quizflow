import 'package:flutter/widgets.dart';
import 'package:quizflow/collection_types/card_deck.dart';
import 'package:quizflow/collection_types/flashcard.dart';

class SelectedDeck extends ChangeNotifier {
  Carddeck? _currentDeck;
  // TODO : set index properly set it as a variable to the class carddeeck

  Carddeck get selectedDeck => _currentDeck!;
  List<Flashcard> get selectedDeckCards =>
      _currentDeck!.flashcards!.cast<Flashcard>();
  int get currentIndex => _currentDeck!.lastIndexReached;
  int get noOfQuestions => _currentDeck!.flashcards!.length;

  void changeWrongNo() {
    if (_currentDeck!.noOfQuestionsWrong < noOfQuestions) {
      _currentDeck!.noOfQuestionsWrong++;
    } else {
      _currentDeck!.noOfQuestionsWrong = 0;
    }
    notifyListeners();
  }

  void changeCorrectNo() {
    if (_currentDeck!.noOfQuestionsCorrect < noOfQuestions) {
      _currentDeck!.noOfQuestionsCorrect++;
    } else {
      _currentDeck!.noOfQuestionsCorrect = 0;
    }
    notifyListeners();
  }

  void selectDeck(Carddeck carddeck) {
    _currentDeck = carddeck;
  }

  void setCurrentIndex(int newIndex) {
    _currentDeck!.lastIndexReached = newIndex;
  }
}
