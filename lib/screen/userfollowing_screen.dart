import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/myprofile_screen.dart';
import 'package:bookkeeperapp/screen/userprofile_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserFollowingScreen extends StatefulWidget {
  static const routeName = '/userProfileScreen/userFollowingScreen';

  @override
  State<StatefulWidget> createState() {
    return _UserFollowingState();
  }
}

class _UserFollowingState extends State<UserFollowingScreen> {
  User user;
  _Controller con;
  BKUser bkUser;
  BKUser userProfile;
  List<BKUser> following;

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
    following ??= args['following'];

    return Scaffold(
      appBar: AppBar(
        title: Text("${userProfile.displayName} is following"),
      ),
      body: userProfile.following.length == 0
          ? Center(
              child: Text(
                '${userProfile.displayName} is not following anyone',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.cyan[900],
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: ListView.builder(
                itemCount: userProfile.following.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.orange[50],
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  child: ClipOval(
                                    child: MyImageView.network(
                                        imageURL: following[index].photoURL,
                                        context: context),
                                  ),
                                ),
                                Container(
                                  child: FlatButton(
                                    onPressed: () => con.goToProfile(index),
                                    child: Text(
                                      following[index].displayName,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.cyan[900],
                                      ),
                                    ),
                                  ),
                                ),
                                following[index].email == bkUser.email
                                    ? SizedBox(
                                        height: 1.0,
                                      )
                                    : Row(
                                        children: <Widget>[
                                          !bkUser.following.contains(
                                                  following[index].email)
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
                                                      onPressed: () =>
                                                          con.follow(index)),
                                                )
                                              : ButtonTheme(
                                                  minWidth: 120.0,
                                                  height: 40.0,
                                                  child: RaisedButton(
                                                      color:
                                                          Colors.orangeAccent,
                                                      child: Text(
                                                        'Unfollow',
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          con.unfollow(index)),
                                                ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _Controller {
  _UserFollowingState _state;
  _Controller(this._state);

  void follow(int index) async {
    _state.render(() {
      if (!_state.bkUser.following.contains(_state.following[index].email)) {
        _state.bkUser.following.add(_state.following[index].email);
        _state.following[index].followers.add(_state.bkUser.email);
      }
    });

    try {
      await FirebaseController.updateFollowing(
          _state.bkUser, _state.following[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error occured, could not follow user',
        content: e.message ?? e.toString(),
      );
    }
  }

  void unfollow(int index) async {
    _state.render(() {
      if (_state.bkUser.following.contains(_state.following[index].email)) {
        _state.bkUser.following.remove(_state.following[index].email);
        _state.following[index].followers.remove(_state.bkUser.email);
      }
    });
    try {
      await FirebaseController.updateFollowing(
          _state.bkUser, _state.following[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error occured, could not unfollow user',
        content: e.message ?? e.toString(),
      );
    }
  }

  void goToProfile(int index) async {
    // get user's info
    List<BKUser> bkUserList =
        await FirebaseController.getBKUser(_state.following[index].email);
    BKUser bkUserProfile = bkUserList[0];

    // get list of user's posts
    List<BKPost> userPosts =
        await FirebaseController.getBKPosts(_state.following[index].email);

    if (_state.following[index].email == _state.bkUser.email) {
      Navigator.pushNamed(_state.context, MyProfileScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'bkPosts': userPosts,
          });
    } else {
      Navigator.pushNamed(_state.context, UserProfileScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'userPosts': userPosts,
            'bkUserProfile': bkUserProfile,
          });
    }
  }
}
