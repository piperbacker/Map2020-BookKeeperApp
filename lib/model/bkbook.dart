class BKBook {
  static const COLLECTION = 'Books';
  static const COVER_FOLDER = 'bookCovers';
  static const FILE_FOLDER = 'bookFiles';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';
  static const FILE_URL = 'fileURL';
  static const FILE_PATH = 'filePath';
  static const TITLE = 'title';
  static const AUTHOR = 'author';
  static const DESC = 'description';
  static const PUB_DATE = 'pubDate';
  static const DOWNLOADS = 'downloads';

  String docId; //Firestore doc ID
  String photoPath; // Firebase storage; image file name
  String photoURL; // Firebase storage; image url for internet access
  String filePath;
  String fileURL;
  String title;
  String author;
  String description;
  DateTime pubDate;
  int downloads;

  BKBook({
    this.docId,
    this.photoPath,
    this.photoURL,
    this.filePath,
    this.fileURL,
    this.title,
    this.author,
    this.description,
    this.pubDate,
    this.downloads,
  }) {
    this.downloads = 0;
  }

  // convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
      FILE_PATH: filePath,
      FILE_URL: fileURL,
      TITLE: title,
      AUTHOR: author,
      DESC: description,
      PUB_DATE: pubDate,
      DOWNLOADS: downloads,
    };
  }

  // convert Firestore document to Dart object
  static BKBook deserialize(Map<String, dynamic> data, String docId) {
    return BKBook(
      docId: docId,
      photoPath: data[BKBook.PHOTO_PATH],
      photoURL: data[BKBook.PHOTO_URL],
      filePath: data[BKBook.FILE_PATH],
      fileURL: data[BKBook.FILE_URL],
      title: data[BKBook.TITLE],
      author: data[BKBook.AUTHOR],
      description: data[BKBook.DESC],
      pubDate: data[BKBook.PUB_DATE] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[BKBook.PUB_DATE].millisecondsSinceEpoch)
          : null,
      downloads: data[BKBook.DOWNLOADS],
    );
  }

  @override
  String toString() {
    return '$docId $photoURL $fileURL $title $author $description';
  }
}
