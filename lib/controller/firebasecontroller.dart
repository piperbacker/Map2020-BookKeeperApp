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
    //String displayName,
    String email,
    String password,
    BKUser user,
  ) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    /*await FirebaseAuth.instance.currentUser.updateProfile(
      displayName: displayName,
    );*/
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(BKUser.COLLECTION)
        .add(user.serialize());
    return ref.id;
  }

  static Future<List<BKUser>> getBKUser(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKUser.COLLECTION)
        .where(BKUser.EMAIL, isEqualTo: email)
        .get();
    var result = <BKUser>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(BKUser.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<Map<String, String>> uploadProfilePic({
    @required File image,
    String filePath,
    @required String uid,
    @required Function listener,
  }) async {
    filePath ??= '${BKUser.PROFILE_FOLDER}/$uid/${DateTime.now()}';

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

  static Future<void> updateProfile({
    @required BKUser bkUser,
  }) async {
    await FirebaseFirestore.instance
        .collection(BKUser.COLLECTION)
        .doc(bkUser.docId)
        .set(bkUser.serialize());
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

  static Future<List<BKPost>> getHomeFeed(List<dynamic> following) async {
    QuerySnapshot querySnapshot;
    var result = <BKPost>[];
    for (var follower in following) {
      querySnapshot = await FirebaseFirestore.instance
          .collection(BKPost.COLLECTION)
          .where(BKPost.POSTED_BY, isEqualTo: follower)
          .get();
      if (querySnapshot != null && querySnapshot.docs.length != 0) {
        for (var doc in querySnapshot.docs) {
          result.add(BKPost.deserialize(doc.data(), doc.id));
        }
      }
    }
    result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
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
        .where(BKUser.DISPLAY_NAME, isEqualTo: displayName)
        .get();

    var result = <BKUser>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(BKUser.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updateFollowing(BKUser bkUser, BKUser userProfile) async {
    if (bkUser.email != userProfile.email) {
      await FirebaseFirestore.instance
          .collection(BKUser.COLLECTION)
          .doc(bkUser.docId)
          .update({"following": bkUser.following});

      await FirebaseFirestore.instance
          .collection(BKUser.COLLECTION)
          .doc(userProfile.docId)
          .update({"followers": userProfile.followers});
    }
  }

  static Future<List<BKUser>> getFollowers(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKUser.COLLECTION)
        .where(BKUser.FOLLOWING, arrayContains: email)
        .get();

    var results = <BKUser>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        results.add(BKUser.deserialize(doc.data(), doc.id));
      }
    }
    return results;
  }

  static Future<List<BKUser>> getFollowing(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKUser.COLLECTION)
        .where(BKUser.FOLLOWERS, arrayContains: email)
        .get();

    var results = <BKUser>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        results.add(BKUser.deserialize(doc.data(), doc.id));
      }
    }
    return results;
  }
}
