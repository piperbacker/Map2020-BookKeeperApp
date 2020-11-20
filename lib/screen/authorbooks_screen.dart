import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'showreviews_screen.dart';
import 'views/myimageview.dart';

class AuthorBooksScreen extends StatefulWidget {
  static const routeName = 'authorHome/authorBooksScreen';

  @override
  State<StatefulWidget> createState() {
    return _AuthorBooksState();
  }
}

class _AuthorBooksState extends State<AuthorBooksScreen> {
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
        title: Text("${bkUser.displayName}'s Books"),
      ),
      body: bkBooks.length == 0
          ? Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              alignment: Alignment.center,
              child: Text(
                'You have not published any books on the BookKeeper App yet',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.cyan[900],
                ),
              ),
            )
          : Container(
              child: ListView.builder(
                itemCount: bkBooks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          child: MyImageView.network(
                              imageURL: bkBooks[index].photoURL,
                              context: context),
                        ),
                        Column(
                          children: [
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
                          ],
                        ),
                        SizedBox(width: 20.0),
                        IconButton(
                          iconSize: 50.0,
                          icon: Icon(Icons.arrow_right),
                          onPressed: () => con.selectBook(index),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _Controller {
  _AuthorBooksState _state;
  _Controller(this._state);

  void selectBook(int index) async {
    // get reviews
    List<BKPost> reviews =
        await FirebaseController.getReviews(_state.bkBooks[index].title);

    Navigator.pushNamed(_state.context, ShowReviewsScreen.routeName,
        arguments: {
          'user': _state.user,
          'bkUser': _state.bkUser,
          'bkBook': _state.bkBooks[index],
          'reviews': reviews,
        });
  }
}
