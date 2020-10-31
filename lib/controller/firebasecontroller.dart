import 'package:bookkeeperapp/model/bookkeeper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class FirebaseController {
  static Future signIn(String email, String password) async {
    UserCredential auth = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return auth.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> signUp(
      String displayName, String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance.currentUser.updateProfile(
        displayName: displayName,
        photoURL:
            'https://firebasestorage.googleapis.com/v0/b/piper-map2020-bookkeeperapp.appspot.com/o/DefaultProfilePicture%2Fdef_profile.png?alt=media&token=0fdeb013-fdcb-413a-9946-e6653cbc241f');
  }

  static Future<void> updateProfile({
    @required File image, // null no update needed
    @required String displayName,
    @required User user,
    @required Function progressListener,
  }) async {
    if (image != null) {
      // 1. upload the picture
      String filePath = '${BookKeeper.PROFILE_FOLDER}/${user.uid}/${user.uid}';
      StorageUploadTask uploadTask =
          FirebaseStorage.instance.ref().child(filePath).putFile(image);

      uploadTask.events.listen((event) {
        double percentage = (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble()) *
            100;
        progressListener(percentage);
      });

      var download = await uploadTask.onComplete;
      String url = await download.ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser
          .updateProfile(displayName: displayName, photoURL: url);
    } else {
      await FirebaseAuth.instance.currentUser
          .updateProfile(displayName: displayName);
    }
  }
}
