import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quizflow/collection_types/card_deck.dart';
import 'package:quizflow/collection_types/collection.dart';
import 'package:quizflow/provider/hive_model.dart';

part 'folder.g.dart';

@HiveType(typeId: 2)
class Folder extends CollectionTypes {
  @HiveField(0)
  String title;

  @HiveField(1)
  double folderLevel;

  @HiveField(2)
  Folder? parent;

  @HiveField(3)
  HiveList<CollectionTypes>? subItems;

  @HiveField(4)
  List<CollectionTypes> subItemsRaw;

  @HiveField(5)
  List<String> pathList;

  @HiveField(6)
  bool isExpanded = false;

  @HiveField(7)
  List<int>? folderColor;

  @HiveField(8)
  int i = 15;

  @HiveField(9)
  String? boxId;

  Folder({
    required this.title,
    required this.folderLevel,
    required this.subItemsRaw,
    required this.pathList,
    required this.parent,
    required this.folderColor,
    required this.boxId,
  }) : super() {
    if (folderLevel == 0) {
      folderColor ??= [
        255 - i * 10,
        Random().nextInt(105) + 50,
        Random().nextInt(105) + 50,
        Random().nextInt(165)
      ];
      //folderColor = Color.fromARGB(255 - i * 5, 83 - i, 80 - i, 164 - i);
    }
    boxId ??= generateRandomString();

    //Future.wait([setUpBox(subItemsRaw)]);

    for (var item in subItemsRaw) {
      if (item is Folder) {
        item.parent = this;
      }
      if (item is Carddeck) {
        item.parent = this;
      }
      if (item is Folder) {
        item.folderColor = folderColor;
      }
    }
  }

  void addItem(CollectionTypes item) {
    if (item is Folder) {
      item.parent = this;
    }
    if (item is Carddeck) {
      item.parent = this;
    }
    subItems!.add(item);
  }

  // void addGroupItem(itemList) {
  //   subItems = [...itemList];
  // }

  void remove(List<CollectionTypes> listItem) {
    listItem.remove(this);
  }

  void setExpansion(bool trueOrFalse) {
    if (subItems != null) {
      isExpanded = trueOrFalse;
    } else {
      isExpanded = false;
    }
  }

  Color getFolderColor() {
    return Color.fromARGB(
        folderColor![0], folderColor![1], folderColor![2], folderColor![3]);
  }

  String generateRandomString() {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random.secure();

    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
