class BKUser {
  static const COLLECTION = 'users';
  static const PROFILE_FOLDER = 'profilePictures';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';
  static const DISPLAY_NAME = 'displayName';
  static const USER = 'user';
  static const USER_BIO = 'userBio';
  static const USER_TAG = 'userTag';
  static const FOLLOWING = 'following';
  static const FOLLOWED_BY = 'followedBy';

  String docId; //Firestore doc ID
  String photoPath; // Firebase storage; image file name
  String photoURL; // Firebase storage; image url for internet access
  String displayName;
  String user;
  String userBio;
  String userTag;
  List<dynamic> following;
  List<dynamic> followedBy;

  BKUser({
    this.docId,
    this.photoPath,
    this.photoURL,
    this.user,
    this.displayName,
    this.userBio,
    this.userTag,
    this.following,
    this.followedBy,
  }) {
    this.following ??= [];
    this.followedBy ??= [];
  }

  // convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
      USER: user,
      DISPLAY_NAME: displayName,
      USER_BIO: userBio,
      USER_TAG: userTag,
      FOLLOWING: following,
      FOLLOWED_BY: followedBy,
    };
  }

  // convert Firestore document to Dart object
  static BKUser deserialize(Map<String, dynamic> data, String docId) {
    return BKUser(
      docId: docId,
      photoPath: data[BKUser.PHOTO_PATH],
      photoURL: data[BKUser.PHOTO_URL],
      user: data[BKUser.USER],
      displayName: data[BKUser.DISPLAY_NAME],
      userBio: data[BKUser.USER_BIO],
      userTag: data[BKUser.USER_TAG],
      following: data[BKUser.FOLLOWING],
      followedBy: data[BKUser.FOLLOWED_BY],
    );
  }

  @override
  String toString() {
    return '$docId $photoURL $user $displayName $userBio $userTag';
  }
}
