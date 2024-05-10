import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/viewmodel/add_card_model.dart';

import 'package:quizflow/viewmodel/hive_model.dart';
import 'package:quizflow/viewmodel/root_folder_viewmodel.dart';
import 'package:quizflow/viewmodel/page_model.dart';
import 'package:quizflow/viewmodel/selected_deck_model.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:quizflow/view/display_cards_screen.dart';
import 'package:quizflow/view/list_screen.dart';
import 'firebase_options.dart';

late Box box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var dir = await getApplicationDocumentsDirectory();
  print(await HiveControl.doesHiveExist());

  if (true) {
    await HiveControl.registerHive();
    RootFolderViewModel rootFolderViewModel = RootFolderViewModel();
    rootFolderViewModel.initializeHive();

    runApp(MyApp(rootFolderViewModel: rootFolderViewModel));
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
  final RootFolderViewModel rootFolderViewModel;
  const MyApp({super.key, required this.rootFolderViewModel});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: ((context) => widget.rootFolderViewModel)),
        ChangeNotifierProvider(create: ((context) => PageModel())),
        ChangeNotifierProvider(create: ((context) => SelectedDeck())),
        ChangeNotifierProvider(create: ((context) => AddCardModel())),
      ],
      child: ScreenUtilInit(
        builder: (context, widget) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          initialRoute: '/home',
          routes: <String, WidgetBuilder>{
            "/home": (BuildContext context) => const ListScreen(),
            "/DisplayCards": (BuildContext context) => DisplayDeck(),
          },
        ),
        designSize: const Size(360, 800),
      ),
    );
  }
}
