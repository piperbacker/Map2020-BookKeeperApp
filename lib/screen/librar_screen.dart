import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryScreen extends StatefulWidget {
  static const routeName = 'home/libraryScreen';

  @override
  State<StatefulWidget> createState() {
    return _LibraryState();
  }
}

class _LibraryState extends State<LibraryScreen> {
  User user;
  BKUser bkUser;
  List<BKBook> bkBooks;
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
    bkBooks ??= args['bkBooks'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: Text("library"),
    );
  }
}

class _Controller {
  _LibraryState _state;
  _Controller(this._state);
}
