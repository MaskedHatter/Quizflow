import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:langchain/langchain.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/collection_types/collection.dart';
import 'package:quizflow/provider/hive_model.dart';
import 'package:quizflow/screen/add_card_screen.dart';
import 'package:quizflow/collection_types/card_deck.dart';
import 'package:quizflow/collection_types/folder.dart';
import 'package:quizflow/provider/page_model.dart';
import 'package:quizflow/provider/root_folder_model.dart';
import 'package:quizflow/screen/settings_screen.dart';
import 'package:quizflow/widgets/list_screen_widgets/carddeck_tile.dart';
import 'package:quizflow/widgets/list_screen_widgets/folder_tile.dart';
import 'package:quizflow/widgets/list_screen_widgets/list_screen_appbar.dart';
import 'dart:io';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController controller = TextEditingController();

  // Main Build Method for ListScreen
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: context.watch<PageModel>().pageIndex == 0
              ? const Size.fromHeight(kToolbarHeight)
              : Size.zero,
          child: const ListScreenAppbar(),
        ),
        body: [
          ListView(children: [
            ...buildListItems(
                context, context.watch<RootFolder>().rootDeckContent()!),
            const SizedBox(
              height: 70,
            )
          ]),
          AddCard(),
          const Settings()
        ][context.watch<PageModel>().pageIndex],
        floatingActionButton: context.watch<PageModel>().pageIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  context
                      .read<RootFolder>()
                      .showTypeDialogue(true, scaffoldKey, controller);

                  // var box = Hive.box("Box");
                  // Flashcard flash = box.get("flashcards");
                  // context.read<AddCardModel>().deckOptions[0].addCard(flash);
                },
                child: const Icon(Icons.add),
              )
            : Container(),
        bottomNavigationBar: NavigationBar(
          height: context.watch<PageModel>().pageIndex != 1 ? 70 : 70,
          onDestinationSelected: (int index) {
            context.read<PageModel>().changePageIndex(index);
          },
          selectedIndex: context.watch<PageModel>().pageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "home",
            ),
            // NavigationDestination(
            //   icon: Icon(Icons.flip_to_front_rounded),
            //   label: "Deck",
            // ),
            NavigationDestination(
              icon: Icon(Icons.add_box),
              label: "add card",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: "settings",
            )
          ],
        ),
      ),
    );
  }

  // Build Method for Items of ListScreen folders and Decks
  List<Widget> buildListItems(
      BuildContext context, List<CollectionTypes> items) {
    List<Widget?> widgetList = items.map<Widget?>((item) {
      if (item is Folder) {
        return Padding(
          key: UniqueKey(),
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: FolderTile(
              textController: controller,
              item: item,
              scaffoldKey: scaffoldKey,
              buildListItems: buildListItems),
        );
      } else if (item is Carddeck) {
        return Padding(
          padding: EdgeInsets.fromLTRB(15 + (10 * item.folderLevel), 0, 15, 0),
          child:
              CarddeckTile(item: item, noOfQuestions: item.getNoOfQuestions()),
        );
      }
      return null;
    }).toList();

    List<Widget> nonNullWidgetList = [];
    for (var widget in widgetList) {
      if (widget != null) {
        nonNullWidgetList.add(widget);
      }
    }

    return nonNullWidgetList;
  }

  Future<List<Document>> fetchDocuments() async {
    final textFilePathFromPdf = await convertPdfToTextAndSaveInDir();
    final loader = TextLoader(textFilePathFromPdf);
    final documents = await loader.load();

    return documents;
  }

  Future<String> convertPdfToTextAndSaveInDir() async {
    // Directory? downloadsPath = await getDownloadsDirectory();
    // Load the PDF document.
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      //type: FileType.custom,
      allowMultiple: false,
      //allowedExtensions: ["png, jpg, jpeg"]
    );
    //final pdfFromAsset = await rootBundle.load('assets/files/test.pdf');
    var bytes = await File(result!.files.single.path!).readAsBytes();
    print(
        "length: ${await File(result.files.single.path!).readAsBytes().toString().length}");

    print("bytes read");
    StringBuffer textBuffer = StringBuffer();

    String text = textBuffer.toString();
    print("text extracted");
    //print(text);
    final localPath = await _localPath;
    //print("${downloadsPath!.path}");
    // File logFile = await File('/storage/emulated/0/Download/Log/logFile.txt')
    //     .writeAsString(zlib.encode(bytes).toString());
    // File pdfFile = await File('/storage/emulated/0/Download/Log/pdfFile.pdf')
    //     .writeAsBytes(bytes);
    File file = File('$localPath/output.txt');
    //await logFile.writeAsString(zlib.encode(bytes).toString());
    print(bytes.toString().length);
    print(zlib.encode(bytes).toString().length);

    final res = await file.writeAsString(text);
    //print(await res.readAsLines());
    print("done");

    return res.path;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Future<void> setUpBox(List<CollectionTypes> collection) async {
  //   log("box");
  //   Box box = await HiveControl.subItemBox(boxId!);
  //   log("box created");
  //   box.addAll(collection);
  //   subItems = HiveList(box);
  // }
}
