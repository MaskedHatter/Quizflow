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
import 'package:quizflow/screen/display_cards_screen.dart';
import 'screen/list_screen.dart';

import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

late Box box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // print("hey");
  var dir = await getApplicationDocumentsDirectory();
  // var dir2 = await getApplicationCacheDirectory();
  // print(dir.path);
  //Hive.deleteBoxFromDisk("Box", path: dir.path);
  // Hive.deleteBoxFromDisk("Box", path: dir2.path);
  // Hive.deleteBoxFromDisk("Box", path: dir2.path);
  //await HiveControl.createHive();
  print(await HiveControl.doesHiveExist());
  //Hive.deleteBoxFromDisk("Box", path: dir.path);
  // bool boxExists = await Hive.boxExists("Box", path: dir.path);
  // print(boxExists);
  // if (!boxExists) {
  //   await Hive.initFlutter(dir.path);
  //   Hive.registerAdapter<Flashcard>(FlashcardAdapter());
  //   Hive.registerAdapter<Duration>(DurationAdapter());
  //   Hive.registerAdapter<Carddeck>(CarddeckAdapter());
  //   Hive.registerAdapter<CarddeckRegister>(CarddeckRegisterAdapter());
  //   //await Hive.deleteBoxFromDisk("Box");
  //   Box boxStorage = await Hive.openBox("Box", path: dir.path);
  //   print("howdy");
  // }

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

  //print(await Hive.openBox("Box", path: dir.path));
  //await Hive.deleteBoxFromDisk("Box", path: dir.path);
  // var boxStorage = await Hive.openBox("Box", path: dir.path);
  // await boxStorage.deleteFromDisk();

  //box.put("flashcards", Flashcard("What is your name", "My name is Dayo"));

  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   if (user == null) {
  //     print('User is currently signed out!');
  //   } else {
  //     print('User is signed in!');
  //   }
  // });
}

class MyApp extends StatefulWidget {
  RootFolder rootFolderModel;
  MyApp({super.key, required this.rootFolderModel});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final List<ListItem> rootFolders;

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
          "/home": (BuildContext context) => ListScreen(),
          "/DisplayCards": (BuildContext context) => DisplayDeck(),
        },
      ),
    );
  }
}
