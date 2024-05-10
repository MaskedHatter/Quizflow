part of 'package:quizflow/viewmodel/root_folder_viewmodel.dart';

extension AddCollectionService on RootFolderViewModel {
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
}
