import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  static Future<String> signUp(
      String displayName, String email, String password, BKUser user) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance.currentUser.updateProfile(
        displayName: displayName,
        photoURL:
            'https://firebasestorage.googleapis.com/v0/b/piper-map2020-bookkeeperapp.appspot.com/o/DefaultProfilePicture%2Fdef_profile.png?alt=media&token=0fdeb013-fdcb-413a-9946-e6653cbc241f');
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(BKUser.COLLECTION)
        .add(user.serialize());
    return ref.id;
  }

  static Future<List<BKUser>> getBKUser(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKUser.COLLECTION)
        .where(BKUser.USER, isEqualTo: email)
        .get();
    var result = <BKUser>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(BKUser.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updateProfile({
    @required File image, // null no update needed
    @required String displayName,
    @required User user,
    @required BKUser bkUser,
    @required Function progressListener,
  }) async {
    if (image != null) {
      // 1. upload the picture
      String filePath = '${BKUser.PROFILE_FOLDER}/${user.uid}/${user.uid}';
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
      await FirebaseFirestore.instance
          .collection(BKUser.COLLECTION)
          .doc(bkUser.docId)
          .update({"userBio": bkUser.userBio});
    } else {
      await FirebaseAuth.instance.currentUser
          .updateProfile(displayName: displayName);
      await FirebaseFirestore.instance
          .collection(BKUser.COLLECTION)
          .doc(bkUser.docId)
          .update({"userBio": bkUser.userBio});
    }
  }

  static Future<List<BKPost>> getBKPosts(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKPost.COLLECTION)
        .where(BKPost.POSTED_BY, isEqualTo: email)
        .orderBy(BKPost.UPDATED_AT, descending: true)
        .get();
    var result = <BKPost>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(BKPost.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<String> addPost(BKPost bKPost) async {
    bKPost.updatedAt = DateTime.now();
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(BKPost.COLLECTION)
        .add(bKPost.serialize());
    return ref.id;
  }

  static Future<void> updateLikedBy(BKPost bkPost) async {
    await FirebaseFirestore.instance
        .collection(BKPost.COLLECTION)
        .doc(bkPost.docId)
        .update({"likedBy": bkPost.likedBy});
  }

  static Future<Map<String, String>> uploadStorage({
    @required File image,
    String filePath,
    @required String uid,
    @required Function listener,
  }) async {
    filePath ??= '${BKPost.POSTS_FOLDER}/$uid/${DateTime.now()}';

    StorageUploadTask task =
        FirebaseStorage.instance.ref().child(filePath).putFile(image);

    task.events.listen((event) {
      double percentage = (event.snapshot.bytesTransferred.toDouble() /
              event.snapshot.totalByteCount.toDouble()) *
          100;
      listener(percentage);
    });
    var download = await task.onComplete;
    String url = await download.ref.getDownloadURL();
    return {'url': url, 'path': filePath};
  }

  static Future<List<BKUser>> searchUsers({
    @required String displayName,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKUser.COLLECTION)
        .where(BKUser.DISPLAY_NAME, isEqualTo: displayName.toLowerCase())
        .get();

    var result = <BKUser>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(BKUser.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }
}
