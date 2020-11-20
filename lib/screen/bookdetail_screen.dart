import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/showreviews_screen.dart';
import 'package:bookkeeperapp/screen/userprofile_screen.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'myprofile_screen.dart';

class BookDetailScreen extends StatefulWidget {
  static const routeName = 'home/bookDetailScreen';

  @override
  State<StatefulWidget> createState() {
    return _BookDetailState();
  }
}

class _BookDetailState extends State<BookDetailScreen> {
  User user;
  BKUser bkUser;
  BKBook bkBook;
  List<BKPost> reviews;
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
    bkBook ??= args['bkBook'];
    reviews ??= args['reviews'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${bkBook.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: 150.0,
              height: 225.0,
              child: MyImageView.network(
                  imageURL: bkBook.photoURL, context: context),
            ),
            Text(
              bkBook.title,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            Text(
              bkBook.author,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.cyan[900],
              ),
            ),
            Divider(height: 50.0, color: Colors.orangeAccent),
            Container(
              margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
              child: Text(
                bkBook.description,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.cyan[900],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            reviews.length == 0
                ? Text(
                    "This book has not been reviewed yet",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )
                : FlatButton(
                    onPressed: () => con.showReviews(),
                    child: Text(
                      'Reviews (${reviews.length})',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
            SizedBox(
              height: 5.0,
            ),
            ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                color: Colors.orangeAccent,
                child: Text(
                  'Download',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => con.download,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _BookDetailState _state;
  _Controller(this._state);

  void download() {}

  void showReviews() {
    Navigator.pushNamed(_state.context, ShowReviewsScreen.routeName,
        arguments: {
          'user': _state.user,
          'bkUser': _state.bkUser,
          'reviews': _state.reviews,
        });
  }

  /*void goToProfile() async {
    // get user's info
    List<BKUser> bkUserList =
        await FirebaseController.getBKUser(_state.bkBook.author);
    BKUser userProfile = bkUserList[0];

    // get list of user's posts
    List<BKPost> userPosts =
        await FirebaseController.getBKPosts(_state.bkBook.author);

    if (_state.bkBook.author == _state.bkUser.email) {
      Navigator.pushNamed(_state.context, MyProfileScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'bkPosts': userPosts,
          });
    } else {
      Navigator.pushNamed(_state.context, UserProfileScreen.routeName,
          arguments: {
            'bkUser': _state.bkUser,
            'userPosts': userPosts,
            'userProfile': userProfile,
          });
    }
  }*/
}
