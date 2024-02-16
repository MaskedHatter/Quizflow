part of 'package:quizflow/provider/root_folder_model.dart';

extension ImportDeck on RootFolder {
  String? getKeyByValue(Map<String, dynamic> map, String targetValue) {
    for (var entry in map.entries) {
      if (entry.value == targetValue) {
        return entry.key;
      }
    }
    return null; // Return null if the value is not found
  }

  Future<Flashcard> getQuestionsAndAnwsers(item, outputDir) async {
    String question = item["sfld"].toString().trim();
    String answer = item["flds"].toString().trim();
    if (answer.contains(RegExp(r'<img[^>]+src="([^"]+)"'))) {
      File mediaFile = File("$outputDir/media");
      List mediaFileContent = await mediaFile.readAsLines();
      RegExp regex = RegExp(r'<img[^>]+src="([^"]+)"');

      Iterable<Match> matches = regex.allMatches(answer);
      print(matches);
      // List imageSide
      // answer <img src="Screenshot_20231118_151954.jpg">.Cool
      // answer <img src="Screenshot_20231118_151954.jpg">.Cool <img src="Screenshot_20231118_151954.jpg">
      // question  Screenshot_20231118_151954.jpg
      for (Match match in matches) {
        // The group at index 1 contains the text between <img src=" and ">
        String? srcText = match.group(1);
        //print(srcText);
        //print(jsonDecode(mediaFileContent[0]));
        Map<String, dynamic> mapMediaText = jsonDecode(mediaFileContent[0]);
        //print(mapMediaText["1"].runtimeType);
        if (srcText != null) {
          String? pictureInt = getKeyByValue(mapMediaText, srcText);
          // TODO create the path and move the image file then add it to the flashcard
          //print(question.contains(mapMediaText[pictureInt]));
          //print(question);
          if (question.contains(mapMediaText[pictureInt])) {
            print("here");
            question = question
                .replaceAll(mapMediaText[pictureInt],
                    '<SpaceBr><|&img src="$outputDir/$pictureInt"&|>\n\n<SpaceBr>')
                .replaceAll(RegExp(r'[^\x20-\x7E]'), '')
                .replaceAll("<br>", '');
            //print("question:\n\n$question");
            answer = answer.replaceAll(
                '<img src="${mapMediaText[pictureInt]}">',
                '<SpaceBr><|&img src="$outputDir/$pictureInt"&|>\n\n<SpaceBr>');
          } else {
            answer = answer.replaceAll(
                '<img src="${mapMediaText[pictureInt]}">',
                '<SpaceBr><|&img src="$outputDir/$pictureInt"&|>\n\n<SpaceBr>');
          }
        }
      }
      // mediaFile.
      List answerStruct = answer.split("<SpaceBr>");
      List questStruct = question.split("<SpaceBr>");
      answerStruct.removeWhere((element) => element.trim().isEmpty);
      questStruct.removeWhere((element) => element.trim().isEmpty);
      print(answerStruct);
      print(questStruct);
      answerStruct = answerStruct.sublist(questStruct.length);
      answer = answerStruct.join(" ");
      question = questStruct.join(" ");
    }
    answer = answer
        .replaceFirst(question, '')
        .replaceAll(RegExp(r'[^\x20-\x7E]'), '');
    answer = answer.replaceAll("<br>", '');
    // answer = answer.replaceAll(
    //RegExp(r'[^\w\s!"#$%&()*+,-./:;<=>?@[\\]^_`{|}~]'), "");
    //answer = answer.substring(containsImages ? 1 : 2);
    //print("question:\n\n$question");
    //print("answer:\n\n$answer");
    print("#######################################");
    return Flashcard(questionText: question, questionAnswer: answer);
  }

  void importFile() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      //type: FileType.custom,
      allowMultiple: false,
      //allowedExtensions: ["zip, apkg, colpkg"]
    );
    if (result != null) {
      File file = File(result.files.single.path!);

      String dirName = path.dirname(file.path);
      String fileName = path.basenameWithoutExtension(file.path);
      String newPath = path.join(dirName, "$fileName.zip");
      file.renameSync(newPath);
      String outputDir = "${appDocDirectory.path}/out/$fileName";
      extractFileToDisk(newPath, outputDir);
      loadImportFile(outputDir);
    } else {
      // User canceled the picker
    }
  }

  void loadImportFile(String outputDir) async {
    var db = await openDatabase('$outputDir/collection.anki2', version: 2);

    // List deckInfo =
    //     await db.rawQuery('SELECT * FROM notes JOIN cards USING (mod)');

    // table contain names of decks and subfolders root::subfolder::sub subfolder
    List deckLabels = await db.rawQuery('SELECT decks FROM col');

    List parsedDeckLabels = deckLabels
        .map(
          (item) {
            var objectDeckLabels = jsonDecode(item["decks"]).values;
            return objectDeckLabels;
          },
        )
        .toList()[0]
        .toList();

    //Gets id, name, folderlevl  and an array of the path to the deck
    List deckRegister = parsedDeckLabels.map((item) {
      List listOfName = item["name"].split("::");
      String name = listOfName[listOfName.length - 1];
      // String parentFolderName =
      //     listOfName.length > 1 ? listOfName[listOfName.length - 2] : "";
      listOfName.removeLast();
      return (
        id: item["id"],
        name: name,
        //parentFolder: parentFolderName,
        pathListForm: listOfName,
        //path: item["name"].substring(0, item["name"].length - name.length),
        children: [],
        folderLevel: listOfName.length
      );
    }).toList();

    // deck is sorted from highest folderlevel to lowest folderlevel
    deckRegister.sort((a, b) => b.folderLevel.compareTo(a.folderLevel));

    // Re-Organises Decks into a tree structure by
    //copying the deck to the parent and marking it for removal
    List toRemove = [];
    for (var currentDeck in deckRegister) {
      for (var compareDeck in deckRegister) {
        if (currentDeck.id == 1) {
          toRemove.add(currentDeck);
        }
        if (listEquals(currentDeck.pathListForm,
            [...compareDeck.pathListForm, compareDeck.name])) {
          compareDeck.children.add(currentDeck);
          toRemove.add(currentDeck);
        }
      }
    }
    deckRegister.removeWhere((element) => toRemove.contains(element));

    List<CollectionTypes> importCollection = [];

    for (var rootDeck in deckRegister) {
      //print(rootDeck.name);
      //print(await organiseCards(rootDeck, db));
      var temp = await organiseCards(rootDeck, db, outputDir);
      // List<ListItem> subItemList =
      //     temp.runtimeType is List<ListItem> ? temp : [temp];
      importCollection.add(temp);
    }
    for (var collection in importCollection) {
      await storeImportedCollection(collection);
    }
    await HiveControl.storeRootDeck(rootFolder);
    notify();
  }

  organiseCards(item, db, dir, [parentItem]) async {
    // Checks if the Deck as any children decks
    if (item.children.isNotEmpty) {
      List<CollectionTypes> subItemList = [];
      // Loops through children of the parent Item
      for (var childItem in item.children) {
        // Runs the through the children
        //of the childen by looping through the function
        var temp = await organiseCards(childItem, db, dir, item);

        // Adds the return value to subItemList
        temp.runtimeType is List<CollectionTypes>
            ? subItemList.addAll(temp)
            : subItemList.add(temp);
      }
      // returns a folder with the parent Item
      // name and the children under it
      Folder folder = Folder(
          title: item.name,
          folderLevel: item.folderLevel.toDouble(),
          subItemsRaw: subItemList,
          pathList: [...item.pathListForm, item.name],
          parent: null,
          folderColor: null,
          boxId: null);
      return folder;
    } else {
      // If no then the Deck is assumed
      //to be a Card deck that stores flashcards
      var frontAndBack = await db.rawQuery(
          'SELECT sfld, flds FROM notes JOIN cards ON notes.id = cards.nid WHERE did = ${item.id}');
      List<Flashcard> flashcards = await Future.wait(
          frontAndBack.map<Future<Flashcard>>((childItem) async {
        Flashcard placeholder = await getQuestionsAndAnwsers(childItem, dir);
        return placeholder;
      }).toList());
      Carddeck deck = Carddeck(
        title: item.name,
        folderLevel: item.folderLevel.toDouble(),
        flashcardsRaw: flashcards,
        pathList: [...item.pathListForm, item.name],
        parent: null,
        intervalModifier: 1,
      );
      return deck;
    }
  }

  Future<void> storeImport(List<CollectionTypes> listCollection) async {
    for (var collection in listCollection) {
      if (collection is Folder) {
        for (var childCollection in collection.subItemsRaw) {
          await storeImportedCollection(collection);
          await storeImport(collection.subItemsRaw);
        }
        if (collection.folderLevel == 1) {
          await storeImportedCollection(rootFolder);
        }
      }
    }
  }
}
