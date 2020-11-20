import 'package:bookkeeperapp/model/bkbook.dart';
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

  static Future<Map<String, String>> uploadBookCover({
    @required File image,
    String filePath,
    @required String uid,
    @required Function listener,
  }) async {
    filePath ??= '${BKBook.COVER_FOLDER}/$uid/${DateTime.now()}';

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

  static Future<Map<String, String>> uploadBookFile({
    @required File bookFile,
    String filePath,
    @required String uid,
    @required Function listener,
  }) async {
    filePath ??= '${BKBook.FILE_FOLDER}/$uid/${DateTime.now()}';

    StorageUploadTask task =
        FirebaseStorage.instance.ref().child(filePath).putFile(bookFile);

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

  static Future<String> addBook(BKBook book) async {
    book.pubDate = DateTime.now();
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(BKBook.COLLECTION)
        .add(book.serialize());
    return ref.id;
  }

  static Future<List<BKBook>> getBKBooks() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(BKBook.COLLECTION).get();
    var result = <BKBook>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(BKBook.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updateBKBook(
    bkBook,
  ) async {
    await FirebaseFirestore.instance
        .collection(BKBook.COLLECTION)
        .doc(bkBook.docId)
        .set(bkBook.serialize());
  }

  static Future<void> deleteBook(BKBook bkBook) async {
    await FirebaseFirestore.instance
        .collection(BKBook.COLLECTION)
        .doc(bkBook.docId)
        .delete();

    await FirebaseStorage.instance.ref().child(bkBook.photoPath).delete();
    await FirebaseStorage.instance.ref().child(bkBook.filePath).delete();
  }

  static Future<List<BKBook>> searchBooks(String title) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKBook.COLLECTION)
        .where(BKBook.TITLE, isEqualTo: title)
        .orderBy(BKBook.PUB_DATE, descending: true)
        .get();

    var result = <BKBook>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(BKBook.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<List<BKPost>> getReviews(String bookTitle) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKPost.COLLECTION)
        .where(BKPost.BOOK_TITLE, isEqualTo: bookTitle)
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

  static Future<List<BKBook>> getAuthorBooks(BKUser user) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(BKBook.COLLECTION)
        .where(BKBook.AUTHOR, isEqualTo: user.displayName)
        .orderBy(BKBook.PUB_DATE, descending: true)
        .get();

    var result = <BKBook>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(BKBook.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updateRecd(BKUser bkUser, BKUser userProfile) async {
    if (bkUser.email != userProfile.email) {
      await FirebaseFirestore.instance
          .collection(BKUser.COLLECTION)
          .doc(bkUser.docId)
          .update({"following": bkUser.following});
    }
  }
}
