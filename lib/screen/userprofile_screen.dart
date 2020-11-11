import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/myfollowers_screen.dart';
import 'package:bookkeeperapp/screen/myfollowing_screen.dart';
import 'package:bookkeeperapp/screen/library_screen.dart';
import 'package:bookkeeperapp/screen/shop_screen.dart';
import 'package:bookkeeperapp/screen/userfollowers_screen.dart';
import 'package:bookkeeperapp/screen/userfollowing_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'myprofile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = 'home/userProfileScreen';

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfileScreen> {
  User user;
  BKUser bkUser;
  BKUser userProfile;
  List<BKPost> userPosts;
  _Controller con;
  int currentIndex = 0;

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
    userProfile ??= args['userProfile'];
    userPosts ??= args['userPosts'];

    return Scaffold(
      appBar: AppBar(
        title: Text("${userProfile.displayName}'s Profile"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 5.0,
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
                            imageURL: userProfile.photoURL, context: context),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        userProfile.displayName,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.cyan[900],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      userProfile.userBio == null
                          ? Container()
                          : Text(
                              userProfile.userBio,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          !bkUser.following.contains(userProfile.email)
                              ? ButtonTheme(
                                  minWidth: 120.0,
                                  height: 40.0,
                                  child: RaisedButton(
                                    color: Colors.teal[400],
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: con.follow,
                                  ),
                                )
                              : ButtonTheme(
                                  minWidth: 120.0,
                                  height: 40.0,
                                  child: RaisedButton(
                                    color: Colors.orangeAccent,
                                    child: Text(
                                      'Unfollow',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: con.unfollow,
                                  ),
                                ),
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: con.following,
                              child: Text(
                                '${userProfile.following.length}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.cyan[900],
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: con.followers,
                              child: Text(
                                '${userProfile.followers.length}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.cyan[900],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Following",
                              style: TextStyle(
                                fontSize: 16.0,
                                //color: Colors.cyan[900],
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "Followers",
                              style: TextStyle(
                                fontSize: 16.0,
                                //color: Colors.cyan[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 50.0, color: Colors.orangeAccent),
                    ],
                  ),
                ],
              ),
            ),
            userPosts.length == 0
                ? Center(
                    child: Text(
                      'No Posts Yet',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.cyan[900],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: userPosts.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                                imageURL: userProfile.photoURL,
                                                context: context),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          userPosts[index].displayName,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.cyan[900],
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
                                            userPosts[index].title,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                            height: 30.0,
                                            color: Colors.orangeAccent),
                                        Text(
                                          userPosts[index].body,
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
                                  userPosts[index].photoURL == null
                                      ? SizedBox(height: 1)
                                      : Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10.0, 5.0, 10.0, 5.0),
                                          child: MyImageView.network(
                                              imageURL:
                                                  userPosts[index].photoURL,
                                              context: context),
                                        ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      !userPosts[index]
                                              .likedBy
                                              .contains(bkUser.email)
                                          ? IconButton(
                                              icon: Icon(Icons.favorite_border),
                                              onPressed: () => con.like(index),
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.favorite),
                                              color: Colors.pink,
                                              onPressed: () =>
                                                  con.unlike(index),
                                            ),
                                      userPosts[index].likedBy.length == 0
                                          ? SizedBox(
                                              height: 1.0,
                                            )
                                          : Text(
                                              '${userPosts[index].likedBy.length} likes',
                                              //overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                    ],
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
    );
  }
}

class _Controller {
  _UserProfileState _state;
  _Controller(this._state);

  void follow() async {
    _state.render(() {
      if (!_state.bkUser.following.contains(_state.userProfile.email)) {
        _state.bkUser.following.add(_state.userProfile.email);
        _state.userProfile.followers.add(_state.bkUser.email);
      }
    });

    try {
      await FirebaseController.updateFollowing(
          _state.bkUser, _state.userProfile);
      //print(_state.userProfile.following);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error occured, could not follow user',
        content: e.message ?? e.toString(),
      );
    }
  }

  void unfollow() async {
    _state.render(() {
      if (_state.bkUser.following.contains(_state.userProfile.email)) {
        _state.bkUser.following.remove(_state.userProfile.email);
        _state.userProfile.followers.remove(_state.bkUser.email);
      }
    });
    try {
      await FirebaseController.updateFollowing(
          _state.bkUser, _state.userProfile);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error occured, could not unfollow user',
        content: e.message ?? e.toString(),
      );
    }
  }

  void following() async {
    List<BKUser> following =
        await FirebaseController.getFollowing(_state.userProfile.email);

    await Navigator.pushNamed(_state.context, UserFollowingScreen.routeName,
        arguments: {
          'user': _state.user,
          'bkUser': _state.bkUser,
          'userProfile': _state.userProfile,
          'following': following
        });
    _state.render(() {});
  }

  void followers() async {
    List<BKUser> followers =
        await FirebaseController.getFollowers(_state.userProfile.email);

    await Navigator.pushNamed(_state.context, UserFollowersScreen.routeName,
        arguments: {
          'user': _state.user,
          'bkUser': _state.bkUser,
          'userProfile': _state.userProfile,
          'followers': followers
        });
    _state.render(() {});
  }

  void like(int index) async {
    _state.render(() {
      if (!_state.userPosts[index].likedBy.contains(_state.bkUser.email)) {
        _state.userPosts[index].likedBy.add(_state.bkUser.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.userPosts[index]);
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
      if (_state.userPosts[index].likedBy.contains(_state.bkUser.email)) {
        _state.userPosts[index].likedBy.remove(_state.bkUser.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.userPosts[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Unlike photo memo error in saving',
        content: e.message ?? e.toString(),
      );
    }
  }
}
