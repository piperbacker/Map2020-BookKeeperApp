class BookKeeper {
  static const COLLECTION = 'bookKeepers';
  static const PROFILE_FOLDER = 'profilePictures';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';

  String docId; //Firestore doc ID
  String photoPath; // Firebase storage; image file name
  String photoURL; // Firebase storage; image url for internet access

  BookKeeper({
    this.docId,
    this.photoPath,
    this.photoURL,
  });
  // convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
    };
  }

  // convert Firestore document to Dart object
  static BookKeeper deserialize(Map<String, dynamic> data, String docId) {
    return BookKeeper(
      docId: docId,
      photoPath: data[BookKeeper.PHOTO_PATH],
      photoURL: data[BookKeeper.PHOTO_URL],
    );
  }

  @override
  String toString() {
    return '$docId $photoURL';
  }
}
