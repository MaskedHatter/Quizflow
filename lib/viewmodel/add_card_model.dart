import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quizflow/collection_types/card_deck.dart';
import 'package:quizflow/collection_types/card_deck_register.dart';

import 'package:quizflow/collection_types/flashcard.dart';

class AddCardModel extends ChangeNotifier {
  Carddeck? _selectedDeck = CarddeckRegister.selectedDeck;

  List<Carddeck> get deckOptions => CarddeckRegister.listOfCarddecks;

  Carddeck? get getSelectedDeck => CarddeckRegister.selectedDeck;

  void selectDeck(Carddeck deck) {
    _selectedDeck = deck;
    notifyListeners();
  }

  void addCardTOSelectedDeck(Flashcard card) {
    _selectedDeck!.addCard(card);
    notifyListeners();
  }

  void createCard(BuildContext context, TextEditingController front,
      TextEditingController back) {
    Flashcard newCard = Flashcard(
        questionText: front.text ?? " ", questionAnswer: back.text ?? " ");
    front.clear();
    back.clear();
    _selectedDeck!.addCard(newCard);
    notifyListeners();

    ///context.read<AddCardModel>().addCardTOSelectedDeck(newCard);
  }

  void importImage(TextEditingController controller) async {
    //Directory appDocDirectory = await getApplicationDocumentsDirectory();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      //type: FileType.custom,
      allowMultiple: true,
      //allowedExtensions: ["png, jpg, jpeg"]
    );

    if (result != null) {
      //File file = File(result.files.single.path!);
      //Image newImage = Image(image: FileImage(file));
      print(result.files);

      for (PlatformFile file in result.files) {
        controller.selection = controller.selection.start == -1
            ? TextSelection.collapsed(offset: 0 + controller.text.length)
            : controller.selection;
        controller.text = controller.text.replaceRange(
            controller.selection.start,
            controller.selection.end,
            '<|&img src="${file.path!}"&|>\n\n');
      }

      // String dirName = path.dirname(file.path);
      // String fileName = path.basenameWithoutExtension(file.path);
      // String newPath = path.join(dirName, "$fileName.zip");
      // file.renameSync(newPath);
    } else {
      // User canceled the picker
    }
  }
}
