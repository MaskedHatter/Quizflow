import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/provider/add_card_model.dart';

import 'package:quizflow/provider/hive_model.dart';
import 'package:quizflow/provider/root_folder_model.dart';
import 'package:quizflow/provider/page_model.dart';
import 'package:quizflow/provider/selected_deck_model.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:quizflow/screen/display_cards_screen.dart';
import 'package:quizflow/screen/list_screen.dart';
import 'firebase_options.dart';

late Box box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var dir = await getApplicationDocumentsDirectory();
  print(await HiveControl.doesHiveExist());

  if (true) {
    await HiveControl.registerHive();
    RootFolder rootFolderModel = RootFolder();
    rootFolderModel.initializeHive();

    runApp(MyApp(rootFolderModel: rootFolderModel));
  } else {
    await Future.forEach(await dir.list().toList(),
        (FileSystemEntity file) async {
      //print(file.path);
      if (file is File && file.path.endsWith('.hive') ||
          file.path.endsWith('.lock')) {
        log("${file.path}");
        await file.delete();
      }
      //print('All Hive boxes deleted from disk.');
    });
  }
}

class MyApp extends StatefulWidget {
  final RootFolder rootFolderModel;
  const MyApp({super.key, required this.rootFolderModel});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => widget.rootFolderModel)),
        ChangeNotifierProvider(create: ((context) => PageModel())),
        ChangeNotifierProvider(create: ((context) => SelectedDeck())),
        ChangeNotifierProvider(create: ((context) => AddCardModel())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        initialRoute: '/home',
        routes: <String, WidgetBuilder>{
          "/home": (BuildContext context) => const ListScreen(),
          "/DisplayCards": (BuildContext context) => DisplayDeck(),
        },
      ),
    );
  }
}
