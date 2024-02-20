import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:quizflow/service/googl_sign_in/src/googledrivehandler_functions.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn =
      GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);

  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    log("${user}");
    // Use the user object for further operations or navigate to a new screen.

    //For the purpose of testing an api key is provided
    GoogleDriveHandler().setAPIKey(
      apiKey: "AIzaSyCDQCq5zf9QQz3COaIUepuGp_ewrENe47w",
    );

    // File? myFile =
    //     await GoogleDriveHandler().getFileFromGoogleDrive(context: context);
    // drive.File file = drive.File();
    // file.name = "mytextfiel";

    // if (myFile != null) {
    //   /// Do something with the file
    //   /// for instance open the file
    //   print("SOMETHING");
    //   OpenFile.open(myFile.path);
    //   print(myFile);
    // } else {
    //   // Discard...
    //   print("NOTHING");
    // }
  } catch (e) {
    log(e.toString());
  }
}
