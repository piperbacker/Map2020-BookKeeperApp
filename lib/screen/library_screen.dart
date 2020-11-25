import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'book_screen.dart';

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
  List<BKBook> library;
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
    library ??= args['library'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        actions: <Widget>[
          IconButton(
              iconSize: 30.0,
              icon: Icon(Icons.delete),
              onPressed: null //con.trash,
              ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.orange[50],
            ),
          ),
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (2 / 3),
              ),
              itemCount: library.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => con.open(index),
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 150.0,
                            height: 225.0,
                            child: MyImageView.network(
                                imageURL: library[index].photoURL,
                                context: context),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              library[index].title,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.cyan[900],
                              ),
                            ),
                          ),
                          Text(
                            library[index].author,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class _Controller {
  _LibraryState _state;
  _Controller(this._state);

  void open(int index) async {
    await Navigator.pushNamed(_state.context, BookScreen.routeName, arguments: {
      'user': _state.user,
      'bkUser': _state.bkUser,
      'book': _state.library[index],
    });
  }
}
