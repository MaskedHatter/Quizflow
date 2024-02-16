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
import 'package:quizflow/provider/hive_model.dart';
import 'package:sqflite/sqflite.dart';

part 'import_model.dart';

List<CollectionTypes> rootFolders = [
  // Folder(
  //   title: 'Folder 1',
  //   folderLevel: 0,
  //   pathList: ["Folder 1"],
  //   parent: null,
  //   folderColor: null,
  //   subItems: [
  //     Folder(
  //       title: 'Subfolder 1.1',
  //       folderLevel: 1,
  //       pathList: ["Folder 1", "Subfolder 1.1"],
  //       parent: null,
  //       folderColor: null,
  //       subItems: [
  //         Carddeck(
  //             title: 'Random',
  //             folderLevel: 2,
  //             pathList: ["Folder 1", "subfolder 1.1", "Random"],
  //             parent: null,
  //             intervalModifier: 1,
  //             flashcards: [
  //               Flashcard(
  //                 "Color of the sky during the day? what is the meanining of life, is there more to this meaningless existence <p>Lorem ipsum dolor sit amet. Et repudiandae itaque et dolores vitae ut minima eius est accusamus nihil aut quae porro. Sed distinctio molestiae non aspernatur dolores eum reprehenderit molestiae ad laboriosam quod ea voluptatem inventore est veniam itaque! </p><p>Ea enim illum et ipsam magnam non quia corporis quo fugiat totam ut provident provident aut corrupti odit ut voluptatem rerum. Ut dolorem earum est nostrum ipsum ad rerum omnis. In quis reiciendis a voluptas tempore ut totam provident et veritatis possimus! Sed nesciunt fugit sit perspiciatis deleniti ut corporis magni aut harum nihil et enim veniam. </p><p>33 dolores numquam est galisum repellat sed facere maxime. Cum dolorem voluptates et asperiores blanditiis vel tempore omnis! Eum quisquam quae ut magni maxime eos culpa doloremque sit odio Quis est aspernatur aliquid sed eius eius sed dolor neque. </p>Color of the sky during the day? what is the meanining of life, is there more to this meaningless existence <p>Lorem ipsum dolor sit amet. Et repudiandae itaque et dolores vitae ut minima eius est accusamus nihil aut quae porro. Sed distinctio molestiae non aspernatur dolores eum reprehenderit molestiae ad laboriosam quod ea voluptatem inventore est veniam itaque! </p><p>Ea enim illum et ipsam magnam non quia corporis quo fugiat totam ut provident provident aut corrupti odit ut voluptatem rerum. Ut dolorem earum est nostrum ipsum ad rerum omnis. In quis reiciendis a voluptas tempore ut totam provident et veritatis possimus! Sed nesciunt fugit sit perspiciatis deleniti ut corporis magni aut harum nihil et enim veniam. </p><p>33 dolores numquam est galisum repellat sed facere maxime. Cum dolorem voluptates et asperiores blanditiis vel tempore omnis! Eum quisquam quae ut magni maxime eos culpa doloremque sit odio Quis est aspernatur aliquid sed eius eius sed dolor neque. </p>Color of the sky during the day? what is the meanining of life, is there more to this meaningless existence <p>Lorem ipsum dolor sit amet. Et repudiandae itaque et dolores vitae ut minima eius est accusamus nihil aut quae porro. Sed distinctio molestiae non aspernatur dolores eum reprehenderit molestiae ad laboriosam quod ea voluptatem inventore est veniam itaque! </p><p>Ea enim illum et ipsam magnam non quia corporis quo fugiat totam ut provident provident aut corrupti odit ut voluptatem rerum. Ut dolorem earum est nostrum ipsum ad rerum omnis. In quis reiciendis a voluptas tempore ut totam provident et veritatis possimus! Sed nesciunt fugit sit perspiciatis deleniti ut corporis magni aut harum nihil et enim veniam. </p><p>33 dolores numquam est galisum repellat sed facere maxime. Cum dolorem voluptates et asperiores blanditiis vel tempore omnis! Eum quisquam quae ut magni maxime eos culpa doloremque sit odio Quis est aspernatur aliquid sed eius eius sed dolor neque. </p>",
  //                 "Blueis there more to this meaningless existence <p>Lorem ipsum dolor sit amet. Et repudiandae itaque et dolores vitae ut minima eius est accusamus nihil aut quae porro. Sed distinctio molestiae non aspernatur dolores eum reprehenderit molestiae ad laboriosam quod ea voluptatem inventore est veniam itaque! </p><p>Ea enim illum et ipsam magnam non quia corporis quo fugiat totam ut provident provident aut corrupti odit ut voluptatem rerum. Ut dolorem earum est nostrum ipsum ad rerum omnis. In quis reiciendis a voluptas tempore ut totam provident et veritatis possimus! Sed nesciunt fugit sit perspiciatis deleniti ut corporis magni aut harum nihil et enim veniam. </p><p>33 dolores numquam est galisum repellat sed facere maxime. Cum dolorem voluptates et asperiores blanditiis vel tempore omnis! Eum quisquam quae ut magni maxime eos culpa doloremque sit odio Quis est aspernatur aliquid sed eius eius sed dolor neque. </p>Color of the sky during the day? what is the meanining of life, is there more to this meaningless existence <p>Lorem ipsum dolor sit amet. Et repudiandae itaque et dolores vitae ut minima eius est accusamus nihil aut quae porro. Sed distinctio molestiae non aspernatur dolores eum reprehenderit molestiae ad laboriosam quod ea voluptatem inventore est veniam itaque! </p><p>Ea enim illum et ipsam magnam non quia corporis quo fugiat totam ut provident provident aut corrupti odit ut voluptatem rerum. Ut dolorem earum est nostrum ipsum ad rerum omnis. In quis reiciendis a voluptas tempore ut totam provident et veritatis possimus! Sed nesciunt fugit sit perspiciatis deleniti ut corporis magni aut harum nihil et enim veniam. </p><p>33 dolores numquam est galisum repellat sed facere maxime. Cum dolorem voluptates et asperiores blanditiis vel tempore omnis! Eum quisquam quae ut magni maxime eos culpa doloremque sit odio Quis est aspernatur aliquid sed eius eius sed dolor neque. </p>Color of the sky during the day? what is the meanining of life, is there more to this meaningless existence <p>Lorem ipsum dolor sit amet. Et repudiandae itaque et dolores vitae ut minima eius est accusamus nihil aut quae porro. Sed distinctio molestiae non aspernatur dolores eum reprehenderit molestiae ad laboriosam quod ea voluptatem inventore est veniam itaque! </p><p>Ea enim illum et ipsam magnam non quia corporis quo fugiat totam ut provident provident aut corrupti odit ut voluptatem rerum. Ut dolorem earum est nostrum ipsum ad rerum omnis. In quis reiciendis a voluptas tempore ut totam provident et veritatis possimus! Sed nesciunt fugit sit perspiciatis deleniti ut corporis magni aut harum nihil et enim veniam. </p><p>33 dolores numquam est galisum repellat sed facere maxime. Cum dolorem voluptates et asperiores blanditiis vel tempore omnis! Eum quisquam quae ut magni maxime eos culpa doloremque sit odio Quis est aspernatur aliquid sed eius eius sed dolor neque. </p",
  //               ),
  //               Flashcard(
  //                 "Shape of a soccer ball?",
  //                 "Spherical",
  //               ),
  //               Flashcard(
  //                 "Capital of France?",
  //                 "Paris",
  //               ),
  //             ]),
  //       ],
  //     ),
  //   ],
  // ),
];

class RootFolder extends ChangeNotifier {
  Folder rootFolder = Folder(
      title: "Root",
      folderLevel: -1,
      subItemsRaw: [],
      pathList: [],
      parent: null,
      folderColor: null,
      boxId: "root");

// Folder for the storage of Carddecks
  // Folder cardDeckFolder = Folder(
  //     title: "Carddeck",
  //     folderLevel: -1,
  //     subItemsRaw: [],
  //     pathList: [],
  //     parent: null,
  //     folderColor: null,
  //     boxId: "carddeck");

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

  int get rootLength => _items!.length;

  // void setItemsContent () {
  //   if
  //   _items = Hive
  // }

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
      CarddeckRegister.selectedDeck = CarddeckRegister.listOfCarddecks.last;
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

  // Future<void> updateHive() async {
  //   //could be written better
  //   //HiveControl.createHive();
  //   log("Storing...");
  //   await HiveControl.storeRootDeck(_items);
  //   log("Hive Updated");
  //   //await HiveControl.storeCarddeckList(CarddeckRegisterModel.register);
  // }

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

  Future<String?> showDeckNameDialogue(
      GlobalKey widgetKey, TextEditingController controller) {
    BuildContext context = widgetKey.currentContext!;
    return showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("New Deck"),
              content: TextField(
                autofocus: true,
                controller: controller,
                decoration: const InputDecoration(hintText: "Enter Name"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(controller.text);
                      controller.clear();
                    },
                    child: const Text("Submit"))
              ],
            ));
  }

  Future<void> showTypeDialogue(
      bool root, GlobalKey widgetKey, TextEditingController controller,
      [parentFolder]) async {
    BuildContext context = widgetKey.currentContext!;
    rootOptions(root) {
      Widget option = root
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 3);
                },
                child: const Text('Import Deck'),
              ),
            )
          : Container();
      return option;
    }

    switch (await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text("Add What?"),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                    child: const Text('Card'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 2);
                    },
                    child: const Text('Subdeck'),
                  ),
                ),
                rootOptions(root)
              ],
            ))) {
      case 1:
        if (parentFolder == null) {
          addCollectionToCollectionRoot(widgetKey, controller, false);
          break;
        }
        addCollectionToCollectionSubcollection(
            parentFolder, widgetKey, controller, false);
        break;
      case 2:
        if (parentFolder == null) {
          addCollectionToCollectionRoot(widgetKey, controller, true);
          break;
        }
        addCollectionToCollectionSubcollection(
            parentFolder, widgetKey, controller, true);
        break;
      case 3:
        importFile();
        break;
      case null:
        break;
    }
  }

  Future<void> storeAddedCollection(Folder parentFolder, collection) async {
    log("Collection ${collection.title} Box ${collection.boxId} Parent ${parentFolder.title} BoxP ${parentFolder.boxId}");
    Box childBox = await HiveControl.subItemBox(collection.boxId);
    if (collection is Folder) {
      collection.subItems = HiveList(childBox);
    } else {
      if (collection is Carddeck) {
        collection.flashcards = HiveList(childBox);
      }
    }
    Box parentBox = await Hive.openBox(parentFolder.boxId!);
    parentBox.add(collection);
    //parentFolder.subItems = HiveList(parentBox);
    parentFolder.subItems!.add(collection);
    if (collection is Carddeck) {
      collection.save();
    }
    if (parentFolder.folderLevel != -1) {
      parentFolder.subItems!
          .sort((a, b) => a is Folder && b is Carddeck ? 0 : 1);
    }
    await parentFolder.save();

    if (collection is Carddeck) {
      CarddeckRegister.updateReg(collection);
    }
    await HiveControl.storeRootDeck(rootFolder);
  }

  Future<void> storeImportedCollection(parentCollection,
      [List<CollectionTypes>? itemHolder]) async {
    log("Collection ${parentCollection.title} Box ${parentCollection.boxId} folderlevel ${parentCollection.folderLevel}, Type ${parentCollection.runtimeType}");
    if (parentCollection is Carddeck || parentCollection is Folder) {
      // Top most folder of Imported decks
      if (parentCollection is Folder) {
        itemHolder ??= parentCollection.subItemsRaw;
        parentCollection.subItemsRaw = [];
      }
      if (parentCollection is Carddeck) {
        itemHolder ??= parentCollection.flashcardsRaw;
        parentCollection.flashcardsRaw = [];
      }
      if (parentCollection.folderLevel == 0) {
        Box rootBox = await HiveControl.openBox(rootFolder.boxId!);
        rootBox.add(parentCollection).catchError((onError) {
          log(onError.toString());
          return 1;
        });
        rootFolder.subItems!.add(parentCollection);
      }

      // Creates the Box for the parent Deck
      Box parentBox = await HiveControl.subItemBox(parentCollection.boxId);

      // Handles flashcards for Carddeck
      if (parentCollection is Carddeck) {
        //CarddeckRegister.updateReg(parentCollection);
        if (itemHolder!.isNotEmpty) {
          await parentBox.addAll(itemHolder).catchError((onError) {
            log("${onError.toString()} Carddeck ${parentCollection.title}");
            return [1];
          });
        }
        parentCollection.flashcards = HiveList(parentBox);
        parentCollection.flashcards!.addAll(itemHolder);
      }

      // Handles Subitems for Folder
      if (parentCollection is Folder) {
        //Checks the subitems to see if they are empty
        if (itemHolder!.isNotEmpty) {
          // If not loops through each item in the subitems
          for (var childCollection in itemHolder) {
            // Acts as an holder for the child subitems
            // so the childCollection can be stored here
            // i.e Stack overflow error is thrown
            List<CollectionTypes>? subItemHolder;
            if (childCollection is Folder) {
              subItemHolder = childCollection.subItemsRaw;
              childCollection.subItemsRaw = [];
            }
            if (childCollection is Carddeck) {
              subItemHolder = childCollection.flashcardsRaw;
              childCollection.flashcardsRaw = [];
            }
            await parentBox.add(childCollection).catchError((onError) {
              if (childCollection is Folder) {
                log("${onError.toString()} Folder ${childCollection.title}");
              }
              if (childCollection is Carddeck) {
                log("${onError.toString()} Carddeck ${childCollection.title}");
              }
              return 1;
            });
            await storeImportedCollection(childCollection, subItemHolder);
          }
        }
        //Box childCollection = await HiveControl.subItemBox(collection.boxId);
        parentCollection.subItems = HiveList(parentBox);
        parentCollection.subItems!.addAll(itemHolder);
      }

      await parentCollection.save();

      if (parentCollection is Folder) {
        log("${parentCollection.title} ${parentCollection.subItems}");
      }
      if (parentCollection is Carddeck) {
        log("${parentCollection.title} ${parentCollection.flashcards}");
      }
    }

    //parentFolder.subItems! = HiveList(parentBox);
    // log("${parentBox.name}");
    // parentBox.add(collection);
    // parentFolder.subItems = HiveList(parentBox);
    // parentFolder.subItems!.add(collection);
    // if (parentFolder.folderLevel != -1) {
    //   parentFolder.subItems!
    //       .sort((a, b) => a is Folder && b is Carddeck ? 0 : 1);
    // }
    // //parentFolder.isExpanded = false;
    // if (parentFolder.isInBox) {
    //   await parentFolder.save();
    // }
    // //parentFolder.isExpanded = true;
    // await HiveControl.storeRootDeck(rootFolder);
  }

  // Future<void> loop(Folder folder,
  //     Future<void> Function(CollectionTypes collection) func) async {
  //   for (CollectionTypes subfolder in folder.subItemsRaw) {
  //     await func(subfolder);
  //   }
  // }
}
