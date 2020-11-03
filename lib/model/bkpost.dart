class BKPost {
  static const COLLECTION = 'BKPosts';
  static const POSTS_FOLDER = 'userPosts';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';
  static const POSTED_BY = 'postedBy';
  static const DISPLAY_NAME = 'displayName';
  static const UPDATED_AT = 'updatedAt';
  static const BOOK_TITLE = 'bookTitle';
  static const AUTHOR = 'author';
  static const TITLE = 'title';
  static const BODY = 'body';
  static const STARS = 'stars';
  static const LIKED_BY = 'likedBy';

  String docId; //Firestore doc ID
  String photoPath; // Firebase storage; image file name
  String photoURL; // Firebase storage; image url for internet access
  String postedBy;
  String displayName;
  DateTime updatedAt;
  String bookTitle;
  String author;
  String title;
  String body;
  int stars;
  List<dynamic> likedBy;

  BKPost(
      {this.docId,
      this.photoPath,
      this.photoURL,
      this.postedBy,
      this.displayName,
      this.updatedAt,
      this.bookTitle,
      this.author,
      this.title,
      this.body,
      this.stars,
      this.likedBy}) {
    this.likedBy ??= [];
  }
  // convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
      POSTED_BY: postedBy,
      DISPLAY_NAME: displayName,
      UPDATED_AT: updatedAt,
      BOOK_TITLE: bookTitle,
      AUTHOR: author,
      TITLE: title,
      BODY: body,
      STARS: stars,
      LIKED_BY: likedBy,
    };
  }

  // convert Firestore document to Dart object
  static BKPost deserialize(Map<String, dynamic> data, String docId) {
    return BKPost(
      docId: docId,
      photoPath: data[BKPost.PHOTO_PATH],
      photoURL: data[BKPost.PHOTO_URL],
      postedBy: data[BKPost.POSTED_BY],
      displayName: data[BKPost.DISPLAY_NAME],
      bookTitle: data[BKPost.BOOK_TITLE],
      author: data[BKPost.AUTHOR],
      title: data[BKPost.TITLE],
      body: data[BKPost.BODY],
      stars: data[BKPost.STARS],
      likedBy: data[BKPost.LIKED_BY],
      updatedAt: data[BKPost.UPDATED_AT] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[BKPost.UPDATED_AT].millisecondsSinceEpoch)
          : null,
    );
  }

  @override
  String toString() {
    return '$docId $photoURL $postedBy $displayName $bookTitle $author $title $body';
  }
}
