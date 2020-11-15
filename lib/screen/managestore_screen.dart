import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/screen/addbook_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageStoreScreen extends StatefulWidget {
  static const routeName = '/adminHome/manageStoreScreen';

  @override
  State<StatefulWidget> createState() {
    return _ManageStoreState();
  }
}

class _ManageStoreState extends State<ManageStoreScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Store'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: con.addBook,
          ),
        ],
      ),
      body: Text("Manage Store"),
    );
  }
}

class _Controller {
  _ManageStoreState _state;
  _Controller(this._state);

  void addBook() {
    Navigator.pushNamed(
      _state.context,
      AddBookScreen.routeName,
    );
  }
}
