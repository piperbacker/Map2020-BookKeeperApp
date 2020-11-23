class BKUser {
  static const COLLECTION = 'users';
  static const LIBRARY = 'library';
  static const PROFILE_FOLDER = 'profilePictures';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';
  static const DISPLAY_NAME = 'displayName';
  static const EMAIL = 'email';
  static const USER_BIO = 'userBio';
  static const USER_TAG = 'userTag';
  static const FOLLOWING = 'following';
  static const FOLLOWERS = 'followers';

  String docId; //Firestore doc ID
  String photoPath; // Firebase storage; image file name
  String photoURL; // Firebase storage; image url for internet access
  String displayName;
  String email;
  String userBio;
  String userTag;
  List<dynamic> library;
  List<dynamic> following;
  List<dynamic> followers;

  BKUser({
    this.docId,
    this.photoPath,
    this.photoURL,
    this.email,
    this.displayName,
    this.userBio,
    this.userTag,
    this.following,
    this.followers,
    this.library,
  }) {
    this.library ??= [];
    this.following ??= [];
    this.followers ??= [];
  }

  // convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      LIBRARY: library,
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
      EMAIL: email,
      DISPLAY_NAME: displayName,
      USER_BIO: userBio,
      USER_TAG: userTag,
      FOLLOWING: following,
      FOLLOWERS: followers,
    };
  }

  // convert Firestore document to Dart object
  static BKUser deserialize(Map<String, dynamic> data, String docId) {
    return BKUser(
      docId: docId,
      library: data[BKUser.LIBRARY],
      photoPath: data[BKUser.PHOTO_PATH],
      photoURL: data[BKUser.PHOTO_URL],
      email: data[BKUser.EMAIL],
      displayName: data[BKUser.DISPLAY_NAME],
      userBio: data[BKUser.USER_BIO],
      userTag: data[BKUser.USER_TAG],
      following: data[BKUser.FOLLOWING],
      followers: data[BKUser.FOLLOWERS],
    );
  }

  @override
  String toString() {
    return '$docId $photoURL $email $displayName $userBio $userTag';
  }
}
