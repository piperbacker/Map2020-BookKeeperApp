import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/home_screen.dart';
import 'package:bookkeeperapp/screen/myprofile_screen.dart';
import 'package:bookkeeperapp/screen/userprofile_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSearchScreen extends StatefulWidget {
  static const routeName = 'home/userSearchScreen';

  @override
  State<StatefulWidget> createState() {
    return _UserSearchState();
  }
}

class _UserSearchState extends State<UserSearchScreen> {
  User user;
  _Controller con;
  BKUser bkUser;
  List<BKUser> results;

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
    results ??= args['results'];

    return Scaffold(
      appBar: AppBar(
        title: Text('User Search'),
      ),
      body: results.length == 0
          ? Center(
              child: Text(
                'There are no users with that Display Name',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.cyan[900],
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: ListView.builder(
                itemCount: results.length,
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
                                        imageURL: results[index].photoURL,
                                        context: context),
                                  ),
                                ),
                                Container(
                                  child: FlatButton(
                                    onPressed: () => con.goToProfile(index),
                                    child: Text(
                                      results[index].displayName,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.cyan[900],
                                      ),
                                    ),
                                  ),
                                ),
                                results[index].email == bkUser.email
                                    ? SizedBox(
                                        height: 1.0,
                                      )
                                    : Row(
                                        children: <Widget>[
                                          !bkUser.following.contains(
                                                  results[index].email)
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
  _UserSearchState _state;
  _Controller(this._state);

  void follow(int index) async {
    print(_state.bkUser.following);
    _state.render(() {
      if (!_state.bkUser.following.contains(_state.results[index].email)) {
        _state.bkUser.following.add(_state.results[index].email);
        _state.results[index].followers.add(_state.bkUser.email);
      }
    });

    //print(_state.bkUser.following);

    try {
      await FirebaseController.updateFollowing(
          _state.bkUser, _state.results[index]);
      print(_state.bkUser.following);
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
      if (_state.bkUser.following.contains(_state.results[index].email)) {
        _state.bkUser.following.remove(_state.results[index].email);
        _state.results[index].followers.remove(_state.bkUser.email);
      }
    });
    try {
      await FirebaseController.updateFollowing(
          _state.bkUser, _state.results[index]);
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
        await FirebaseController.getBKUser(_state.results[index].email);
    BKUser userProfile = bkUserList[0];

    // get list of user's posts
    List<BKPost> userPosts =
        await FirebaseController.getBKPosts(_state.results[index].email);

    if (_state.results[index].email == _state.bkUser.email) {
      Navigator.pushNamed(_state.context, MyProfileScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'bkPosts': userPosts,
          });
    } else {
      await Navigator.pushNamed(_state.context, UserProfileScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'userPosts': userPosts,
            'userProfile': userProfile,
          });
      _state.render(() {});
    }
  }
}
