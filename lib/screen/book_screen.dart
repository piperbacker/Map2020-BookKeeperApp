import 'dart:async';
import 'dart:js';

import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class BookScreen extends StatefulWidget {
  static const routeName = '/library/bookScreen';

  @override
  State<StatefulWidget> createState() {
    return _BookState();
  }
}

class _BookState extends State<BookScreen> {
  User user;
  BKUser bkUser;
  BKBook book;
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    bkUser ??= args['bkUser'];
    book ??= args['book'];

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: null, //con.book,
    );
  }
}

class _Controller {
  _BookState _state;
  _Controller(this._state);
  String file;

  /*void book() {

     file = _state.book.filePath;

    LaunchFile.loadFromFirebase(context, file)
        //Creating PDF file at disk for ios and android & assigning pdfUrl for web
        .then((url) => LaunchFile.createFileFromPdfUrl(url).then(
              (f) => _state.render(
                () {
                  if (f is File) {
                    pathPDF = f.path;
                  } else if (url is Uri) {
                    //Open PDF in tab (Web)
                    pdfUrl = url.toString();
                  }
                },
              ),
            ));
}*/
}
