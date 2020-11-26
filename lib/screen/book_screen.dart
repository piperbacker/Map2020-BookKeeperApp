import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: PDF().cachedFromUrl(
            book.fileURL,
            placeholder: (progress) => Center(child: Text('$progress %')),
            errorWidget: (error) => Center(child: Text(error.toString())),
          ),
        ));
  }
}

class _Controller {
  _BookState _state;
  _Controller(this._state);
}
