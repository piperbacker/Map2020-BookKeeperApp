import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/myfollowers_screen.dart';
import 'package:bookkeeperapp/screen/myfollowing_screen.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'settings_screen.dart';

class MyProfileScreen extends StatefulWidget {
  static const routeName = '/myProfileScreen';

  @override
  State<StatefulWidget> createState() {
    return _MyProfileState();
  }
}

class _MyProfileState extends State<MyProfileScreen> {
  User user;
  BKUser bkUser;
  List<BKPost> bkPosts;
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
    bkPosts ??= args['bkPosts'];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 30.0,
            onPressed: con.settings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: ClipOval(
                          child: MyImageView.network(
                              imageURL: bkUser.photoURL, context: context),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              bkUser.displayName,
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.cyan[900],
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            bkUser.userTag != 'author'
                                ? SizedBox(
                                    height: 1,
                                  )
                                : Icon(
                                    Icons.check_circle,
                                    color: Colors.amber[300],
                                    size: 24.0,
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        bkUser.userBio == null
                            ? Container()
                            : Text(
                                bkUser.userBio,
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            bkUser.userTag == 'author'
                                ? SizedBox(height: 1)
                                : Column(
                                    children: [
                                      FlatButton(
                                        onPressed: con.following,
                                        child: Text(
                                          '${bkUser.following.length}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.cyan[900],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Following",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: con.followers,
                                  child: Text(
                                    '${bkUser.followers.length}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.cyan[900],
                                    ),
                                  ),
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(height: 30.0, color: Colors.orangeAccent),
                      ],
                    ),
                  ],
                ),
              ),
              bkPosts.length == 0
                  ? Center(
                      child: Text(
                        'No Posts Yet',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.cyan[900],
                        ),
                      ),
                    )
                  : Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: bkPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.orange[50],
                            child: Container(
                              margin:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                                                  imageURL: bkUser.photoURL,
                                                  context: context),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            bkPosts[index].displayName,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.cyan[900],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          bkUser.userTag != 'author'
                                              ? SizedBox(
                                                  height: 1,
                                                )
                                              : Icon(
                                                  Icons.check_circle,
                                                  color: Colors.amber[300],
                                                  size: 24.0,
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
                                          bkPosts[index].photoURL == null
                                              ? SizedBox(height: 1)
                                              : Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  margin: EdgeInsets.fromLTRB(
                                                      10.0, 5.0, 10.0, 5.0),
                                                  child: MyImageView.network(
                                                      imageURL: bkPosts[index]
                                                          .photoURL,
                                                      context: context),
                                                ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          bkPosts[index].bookTitle == null
                                              ? SizedBox(height: 1)
                                              : Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        bkPosts[index]
                                                            .bookTitle,
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        bkPosts[index].author,
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color:
                                                              Colors.cyan[900],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          bkPosts[index].asking != null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${bkPosts[index].asking} asks...',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.cyan[900],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Text(
                                                      bkPosts[index].question,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Center(
                                                  child: Text(
                                                    bkPosts[index].title,
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                          Divider(
                                              height: 30.0,
                                              color: Colors.orangeAccent),
                                          bkPosts[index].stars == null
                                              ? SizedBox(
                                                  height: 1,
                                                )
                                              : Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: SmoothStarRating(
                                                    allowHalfRating: false,
                                                    starCount: 5,
                                                    rating: bkPosts[index]
                                                        .stars
                                                        .toDouble(),
                                                    size: 30.0,
                                                    isReadOnly: true,
                                                    color:
                                                        Colors.deepOrange[400],
                                                    borderColor: Colors.grey,
                                                    spacing: 0.0,
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            bkPosts[index].body,
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
                                    bkPosts[index].likedBy.length == 0
                                        ? SizedBox(
                                            height: 1.0,
                                          )
                                        : Text(
                                            '${bkPosts[index].likedBy.length} likes',
                                            //overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _MyProfileState _state;
  _Controller(this._state);

  void settings() async {
    await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
        arguments: {'user': _state.user, 'bkUser': _state.bkUser});

    _state.render(() {});
  }

  void following() async {
    List<BKUser> following =
        await FirebaseController.getFollowing(_state.bkUser.email);

    await Navigator.pushNamed(_state.context, MyFollowingScreen.routeName,
        arguments: {
          'user': _state.user,
          'bkUser': _state.bkUser,
          'following': following
        });
    _state.render(() {});
  }

  void followers() async {
    List<BKUser> followers =
        await FirebaseController.getFollowers(_state.bkUser.email);

    await Navigator.pushNamed(_state.context, MyFollowersScreen.routeName,
        arguments: {
          'user': _state.user,
          'bkUser': _state.bkUser,
          'followers': followers,
        });
    _state.render(() {});
  }
}
