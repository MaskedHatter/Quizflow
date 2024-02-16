import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/domain/signin.dart';
import 'package:quizflow/provider/page_model.dart';
import 'package:quizflow/provider/root_folder_model.dart';

class ListScreenAppbar extends StatelessWidget {
  //final Function signInWithGoogle;
  const ListScreenAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<PageModel>().pageIndex == 0
        ? AppBar(
            title: const Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 00),
              child: Text("QuizFlow",
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    //fontSize: 18,
                    fontFamily: "Exo",
                    color: Color.fromARGB(255, 255, 255, 255),
                  )),
            ),
            scrolledUnderElevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: IconButton(
                    onPressed: () async {
                      //await signInWithGoogle(context);
                      //LangChainService langchain = LangChainService();
                      //final docs = await fetchDocuments();
                      // await langchain.uploadToPineconeIndex(docs);
                      // var result = await langchain.queryPineConeVectorStore(
                      //     "tell me about the first lower molars");
                      // print(
                      //     "#############################################");
                      // print(result);
                      delete();
                      context.read<RootFolder>().clearFolder();
                    },
                    icon: const Icon(Icons.storage)),
              )
            ],
          )
        : PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
            ));
  }
}

void delete() async {
  var dir = await getApplicationDocumentsDirectory();
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
