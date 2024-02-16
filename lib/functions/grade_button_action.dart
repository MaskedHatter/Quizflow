import 'package:quizflow/collection_types/flashcard.dart';

abstract class GradeButtonAction {
  void newCard(Flashcard card);
  void graduated(Flashcard card);
  void lapsed(Flashcard card);
}
