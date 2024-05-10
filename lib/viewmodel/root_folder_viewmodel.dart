import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizflow/collection_types/card_deck.dart';
import 'package:quizflow/collection_types/card_deck_register.dart';
import 'package:quizflow/collection_types/collection.dart';

import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/collection_types/folder.dart';
import 'package:quizflow/viewmodel/hive_model.dart';
import 'package:sqflite/sqflite.dart';

part 'services/rootfolder_services/import_collection_service.dart';
part 'services/rootfolder_services/add_collection_service.dart';
part 'services/rootfolder_services/dialogue_service.dart';

class RootFolderViewModel extends ChangeNotifier {
  Folder rootFolder = Folder(
      title: "Root",
      folderLevel: -1,
      subItemsRaw: [],
      pathList: [],
      parent: null,
      folderColor: null,
      boxId: "root");

  final List<CollectionTypes> _items = [];

  List<CollectionTypes>? rootDeckContent() {
    log("Root items ${rootFolder.subItems?.toList()}");
    // CollectionTypes fo = rootFolder.subItems![0];
    // if (fo is Folder) {
    //   log("childRoot items ${fo.subItems}");
    // }
    return rootFolder.subItems == null ? _items : rootFolder.subItems!.toList();
  }

  void clearFolder() {
    Folder folder = Folder(
        title: "Root",
        folderLevel: -1,
        subItemsRaw: [],
        pathList: [],
        parent: null,
        folderColor: null,
        boxId: "root");
    rootFolder = folder;
    notifyListeners();
  }

  int get rootLength => _items.length;

  void notify() async {
    //await updateHive();
    notifyListeners();
  }

  void initializeHive() async {
    if (await HiveControl.doesHiveExist()) {
      log("Hive already Exists");
      await HiveControl.openHive();
      rootFolder = await HiveControl.getRootDeck();
      CarddeckRegister.listOfCarddecks = await HiveControl.openAllBoxes();
      if (CarddeckRegister.listOfCarddecks.isNotEmpty) {
        CarddeckRegister.selectedDeck = CarddeckRegister.listOfCarddecks.last;
      }
    } else {
      log("Creating Hive...");
      await createHive();
      rootFolder = await HiveControl.getRootDeck();
      Box rootbox = await HiveControl.subItemBox(rootFolder.boxId!);
      rootFolder.subItems = HiveList(rootbox);
      CarddeckRegister.listOfCarddecks = [];
    }
    notifyListeners();
  }

  Future<void> createHive() async {
    await HiveControl.createHive();
  }

  void setExpansionforFolder(Folder folder, bool trueOrFalse) {
    folder.setExpansion(trueOrFalse);
    notifyListeners();
  }

  void removeItem(Folder item) async {
    HiveControl.boxNames.removeWhere((element) =>
        element.toLowerCase() == item.subItems!.box.name.toLowerCase());
    // var value = HiveControl.boxNames.remove(item.subItems!.box.name);
    await HiveControl.saveBoxNames();
    log("${HiveControl.boxNames}");
    item.subItems!.box.deleteFromDisk();
    item.delete();
    notifyListeners();
  }

  void deleteCarddecks(Folder item) {
    for (CollectionTypes child in item.subItems!) {
      if (child is Carddeck) {
        CarddeckRegister.listOfCarddecks.remove(child);
      } else {
        if (child is Folder) {
          deleteCarddecks(child);
        }
      }
    }
  }

  void addCollectionToCollectionSubcollection(
      Folder parentFolder,
      GlobalKey widgetKey,
      TextEditingController controller,
      bool isFolder) async {
    final name = await showDeckNameDialogue(widgetKey, controller);
    var collection;
    if (isFolder) {
      collection = Folder(
          title: "$name",
          folderLevel: parentFolder.folderLevel + 1,
          subItemsRaw: [],
          pathList: [...parentFolder.pathList, "$name"],
          parent: parentFolder,
          folderColor: parentFolder.folderColor,
          boxId: null);
    } else {
      collection = Carddeck(
        title: "$name",
        folderLevel: parentFolder.folderLevel + 1,
        flashcardsRaw: [],
        pathList: [...parentFolder.pathList, "$name"],
        parent: parentFolder,
        intervalModifier: 1,
      );
    }
    await storeAddedCollection(parentFolder, collection);
    notifyListeners();
  }

  void addCollectionToCollectionRoot(
    GlobalKey widgetKey,
    TextEditingController controller,
    bool isFolder,
  ) async {
    final name = await showDeckNameDialogue(widgetKey, controller);
    var collection;
    if (isFolder) {
      collection = Folder(
          title: "$name",
          folderLevel: 0,
          subItemsRaw: [],
          pathList: ["$name"],
          parent: null,
          folderColor: null,
          boxId: null);
    } else {
      collection = Carddeck(
        title: "$name",
        folderLevel: 0,
        flashcardsRaw: [],
        pathList: ["$name"],
        parent: null,
        intervalModifier: 1,
      );
    }
    await storeAddedCollection(rootFolder, collection);
    notifyListeners();
  }

  // Future<void> loop(Folder folder,
  //     Future<void> Function(CollectionTypes collection) func) async {
  //   for (CollectionTypes subfolder in folder.subItemsRaw) {
  //     await func(subfolder);
  //   }
  // }
}
