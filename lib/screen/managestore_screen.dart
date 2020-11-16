import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/screen/addbook_screen.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'editbook_screen.dart';

class ManageStoreScreen extends StatefulWidget {
  static const routeName = '/adminHome/manageStoreScreen';

  @override
  State<StatefulWidget> createState() {
    return _ManageStoreState();
  }
}

class _ManageStoreState extends State<ManageStoreScreen> {
  User user;
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
    bkBooks ??= args['bkBooks'];

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
                childAspectRatio: (1 / 1.85),
              ),
              itemCount: bkBooks.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 225.0,
                          child: MyImageView.network(
                              imageURL: bkBooks[index].photoURL,
                              context: context),
                        ),
                        Text(
                          bkBooks[index].title,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          bkBooks[index].author,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.cyan[900],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ButtonTheme(
                          height: 40.0,
                          child: RaisedButton(
                            color: Colors.orangeAccent,
                            child: Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => con.updateBook(index),
                          ),
                        )
                      ],
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
  _ManageStoreState _state;
  _Controller(this._state);

  void addBook() async {
    await Navigator.pushNamed(_state.context, AddBookScreen.routeName,
        arguments: {'user': _state.user, 'bkBooks': _state.bkBooks});

    _state.render(() {});
  }

  void updateBook(int index) async {
    await Navigator.pushNamed(_state.context, EditBookScreen.routeName,
        arguments: {'user': _state.user, 'bkBook': _state.bkBooks[index]});

    _state.render(() {});
  }
}
