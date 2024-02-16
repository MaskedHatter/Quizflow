import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizflow/collection_types/card_deck.dart';
import 'package:quizflow/collection_types/card_deck_register.dart';
import 'package:quizflow/collection_types/collection.dart';
import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/collection_types/folder.dart';
import 'package:quizflow/main.dart';
import 'package:quizflow/provider/root_folder_model.dart';

class HiveControl {
  static Box? boxStorage;

  static List<String> boxNames = [];

  static Future<void> registerHive() async {
    log("registering adapters...");
    String path = (await getApplicationDocumentsDirectory()).path;
    await Hive.initFlutter(path);
    Hive.registerAdapter<CollectionTypes>(CollectionTypesAdapter());
    Hive.registerAdapter<Folder>(FolderAdapter());
    Hive.registerAdapter<Flashcard>(FlashcardAdapter());
    Hive.registerAdapter<Duration>(DurationAdapter());
    Hive.registerAdapter<Carddeck>(CarddeckAdapter());
    //Hive.registerAdapter<CarddeckRegister>(CarddeckRegisterAdapter());
    //await Hive.deleteBoxFromDisk("Box");
    if (Hive.isAdapterRegistered(1)) {
      log("Carddeck is registered");
    }
    if (Hive.isAdapterRegistered(2)) {
      log("Folder is registered");
    }
    if (Hive.isAdapterRegistered(3)) {
      log("CarddeckReg is registered");
    }
    if (Hive.isAdapterRegistered(0)) {
      log("Flashcard is registered");
    }
    if (Hive.isAdapterRegistered(100)) {
      log("Duration is registered");
    }
    log("registration done");
  }

  static Future<void> createHive() async {
    // Bring the box creation outside of this class
    bool boxExists = await doesHiveExist();
    if (!boxExists) {
      boxStorage = await openBox("Box");
      log("created");
      storeRootDeck(RootFolder().rootFolder);
    }
  }

  static Future<void> openHive() async {
    boxStorage = await openBox("Box");
    boxNames = await boxStorage!.get("boxnames");
  }

  static Future<List<Carddeck>> openAllBoxes() async {
    log("Opening boxes ${boxNames}");
    List<Carddeck> returnList = [];
    for (String name in boxNames) {
      Box box = await openBox(name);
      for (var element in box.values) {
        if (element is Carddeck) {
          returnList.add(element);
        }
      }
      log("Opened $name");
    }
    return returnList;
  }

  static Future<bool> doesHiveExist() async {
    var dir = await getApplicationDocumentsDirectory();
    return await Hive.boxExists("Box", path: dir.path);
  }

  static Future<Box> openBox(String id) async {
    var dir = await getApplicationDocumentsDirectory();
    log("$id");
    Box box = await Hive.openBox(id, path: dir.path);
    return box;
  }

  static Future<Box> subItemBox(String? boxId) async {
    log("Box ${boxId}");
    if (!boxNames.contains(boxId)) {
      boxNames.add(boxId!);
      boxStorage = await openBox("Box");
      await saveBoxNames();
    }
    log("boxNames ${boxNames}");
    return await openBox(boxId!);
  }

  static Future<void> saveBoxNames() async {
    await boxStorage!.put("boxnames", boxNames);
  }

  // ROOT DECK
  static Future<void> storeRootDeck(Folder rootdeck) async {
    log("Creating rootDeckbox");
    await boxStorage!.put("rootdeck", rootdeck);
    log("Done");
  }

  static Future<Folder> getRootDeck() async {
    log("hive is returning");
    var returnValue = await boxStorage!.get("rootdeck");
    log("root hive returned");
    return returnValue;
  }

  // // CARD DECK
  // static Future<void> storeCardDeck(Folder cardDeckFolder) async {
  //   await boxStorage!.put("carddeck", cardDeckFolder);
  //   log("Register saved");
  // }

  // static Future<Folder> getCardDeck() async {
  //   var returnValue = await boxStorage!.get("carddeck");
  //   return returnValue;
  // }
}
