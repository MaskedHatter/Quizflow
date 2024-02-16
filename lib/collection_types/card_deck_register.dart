import 'package:quizflow/collection_types/card_deck.dart';

class CarddeckRegister {
  static List<Carddeck> listOfCarddecks = [];

  static Carddeck? selectedDeck;

  static void updateReg(Carddeck carddeck) {
    listOfCarddecks.add(carddeck);
    selectedDeck = carddeck;
  }
}
