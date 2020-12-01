import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/userprofile_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'myprofile_screen.dart';

class ShowReviewsScreen extends StatefulWidget {
  static const routeName = '/bookDetailScreen/showReviewsScreen';

  @override
  State<StatefulWidget> createState() {
    return _ShowReviewsState();
  }
}

class _ShowReviewsState extends State<ShowReviewsScreen> {
  User user;
  BKUser bkUser;
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
    reviews ??= args['reviews'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews (${reviews.length})'),
      ),
      body: reviews.length == 0
          ? Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              alignment: Alignment.center,
              child: Text(
                'This book has not been reviewed yet.',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.cyan[900],
                ),
              ),
            )
          : Container(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  var u = con.getUserInfo(index);
                  return FutureBuilder<BKUser>(
                    future: u,
                    builder: (context, snapshot) {
                      BKUser userInfo = snapshot.data;
                      if (snapshot.hasData) {
                        return Container(
                          color: Colors.orange[50],
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 10.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          child: ClipOval(
                                            child: MyImageView.network(
                                                imageURL: userInfo.photoURL,
                                                context: context),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        FlatButton(
                                          onPressed: () =>
                                              con.goToProfile(index),
                                          child: Text(
                                            reviews[index].displayName,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.cyan[900],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            reviews[index].title,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                            height: 30.0,
                                            color: Colors.orangeAccent),
                                        Container(
                                          alignment: Alignment.topCenter,
                                          child: SmoothStarRating(
                                            allowHalfRating: false,
                                            starCount: 5,
                                            rating:
                                                reviews[index].stars.toDouble(),
                                            size: 30.0,
                                            isReadOnly: true,
                                            color: Colors.deepOrange[400],
                                            borderColor: Colors.grey,
                                            spacing: 0.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          reviews[index].body,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      reviews[index].postedBy == bkUser.email
                                          ? SizedBox(
                                              height: 1.0,
                                            )
                                          : Row(
                                              children: <Widget>[
                                                !reviews[index]
                                                        .likedBy
                                                        .contains(bkUser.email)
                                                    ? IconButton(
                                                        icon: Icon(Icons
                                                            .favorite_border),
                                                        onPressed: () =>
                                                            con.like(index),
                                                      )
                                                    : IconButton(
                                                        icon: Icon(
                                                            Icons.favorite),
                                                        color: Colors.pink,
                                                        onPressed: () =>
                                                            con.unlike(index),
                                                      ),
                                              ],
                                            ),
                                      reviews[index].likedBy.length == 0
                                          ? SizedBox(
                                              height: 1.0,
                                            )
                                          : Flexible(
                                              child: Text(
                                                '${reviews[index].likedBy.length} likes',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
    );
  }
}

class _Controller {
  _ShowReviewsState _state;
  _Controller(this._state);

  void like(int index) async {
    _state.render(() {
      if (!_state.reviews[index].likedBy.contains(_state.bkUser.email)) {
        _state.reviews[index].likedBy.add(_state.bkUser.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.reviews[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Like photo memo error in saving',
        content: e.message ?? e.toString(),
      );
    }
  }

  void unlike(int index) async {
    _state.render(() {
      if (_state.reviews[index].likedBy.contains(_state.bkUser.email)) {
        _state.reviews[index].likedBy.remove(_state.bkUser.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.reviews[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Unlike photo memo error in saving',
        content: e.message ?? e.toString(),
      );
    }
  }

  Future<BKUser> getUserInfo(int index) async {
    List<BKUser> bkUserList =
        await FirebaseController.getBKUser(_state.reviews[index].postedBy);
    BKUser userInfo = bkUserList[0];
    return userInfo;
  }

  void goToProfile(int index) async {
    // get user's info
    List<BKUser> bkUserList =
        await FirebaseController.getBKUser(_state.reviews[index].postedBy);
    BKUser userProfile = bkUserList[0];

    // get list of user's posts
    List<BKPost> userPosts =
        await FirebaseController.getBKPosts(_state.reviews[index].postedBy);

    if (_state.reviews[index].postedBy == _state.bkUser.email) {
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
  }
}
