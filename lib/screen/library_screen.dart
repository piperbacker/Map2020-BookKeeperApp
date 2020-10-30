import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  static const routeName = '/homeScreen/libraryScreen';

  @override
  State<StatefulWidget> createState() {
    return _LibraryState();
  }
}

class _LibraryState extends State<LibraryScreen> {
  User user;
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: Text("Library"),
    );
  }
}

class _Controller {
  _LibraryState _state;
  _Controller(this._state);
}
