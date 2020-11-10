import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  static const routeName = 'home/libraryScreen';

  @override
  State<StatefulWidget> createState() {
    return _LibraryState();
  }
}

class _LibraryState extends State<LibraryScreen> {
  BKUser bkUser;
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
    bkUser ??= arg['bkUser'];

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
