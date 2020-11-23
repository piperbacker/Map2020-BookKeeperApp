import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'bookdetail_screen.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shopScreen';

  @override
  State<StatefulWidget> createState() {
    return _ShopState();
  }
}

class _ShopState extends State<ShopScreen> {
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
        title: Text('Book Store'),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 225.0,
                          child: MyImageView.network(
                              imageURL: bkBooks[index].photoURL,
                              context: context),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: FlatButton(
                            onPressed: () => con.bookDetails(index),
                            child: Text(
                              bkBooks[index].title,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.cyan[900],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          bkBooks[index].author,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        /*bkBooks[index].downloaded == true
                            ? Text('This book is already in your library')
                            : */
                        ButtonTheme(
                          height: 40.0,
                          child: RaisedButton(
                            color: Colors.orangeAccent,
                            child: Text(
                              'Download',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => con.download(index),
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
  _ShopState _state;
  _Controller(this._state);

  void download(int index) async {
    // _state.bkBooks[index].downloaded = true;
    _state.bkUser.library.add((_state.bkBooks[index].title));
    await FirebaseController.downloadBook(_state.bkUser);
    _state.render(() {});
  }

  void bookDetails(int index) async {
    // get book reviews
    List<BKPost> reviews =
        await FirebaseController.getReviews(_state.bkBooks[index].title);

    Navigator.pushNamed(_state.context, BookDetailScreen.routeName, arguments: {
      'user': _state.user,
      'bkUser': _state.bkUser,
      'bkBook': _state.bkBooks[index],
      'reviews': reviews
    });
  }
}
