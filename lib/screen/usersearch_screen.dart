import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/home_screen.dart';
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
  List<BKUser> bkUsers;
  var formKey = GlobalKey<FormState>();

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
    bkUsers ??= args['bkUsers'];

    return Scaffold(
      appBar: AppBar(
        title: Text('User Search'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
            width: 160.0,
            child: Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Users',
                  fillColor: Colors.white,
                  filled: true,
                ),
                autocorrect: false,
                onSaved: con.onSavedSearchKey,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: con.search,
          ),
        ],
      ),
      body: bkUsers.length == 0
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
                itemCount: bkUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.orange[50],
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  child: ClipOval(
                                    child: MyImageView.network(
                                        imageURL: user.photoURL,
                                        context: context),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                FlatButton(
                                  onPressed:  () => con.goToProfile(index),
                                  child: Text(
                                    bkUsers[index].displayName,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.cyan[900],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                bkUsers[index].user == user.email
                                    ? SizedBox(
                                        height: 1.0,
                                      )
                                    : Row(
                                        children: <Widget>[
                                          !bkUser.following
                                                  .contains(bkUsers[index].user)
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
                                                      onPressed: () => con.follow(
                                                          index) 
                                                      ),
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
  String searchKey;

  void onSavedSearchKey(String value) {
    searchKey = value;
  }

  void search() async {
    _state.formKey.currentState.save();

    var results;
    if (searchKey == null || searchKey.trim().isEmpty) {
      /*Navigator.pushNamed(_state.context, HomeScreen.routeName,
          arguments: {'user': _state.user, 'bkUser': _state.bkUser});*/
    } else {
      results = await FirebaseController.searchUsers(displayName: searchKey);

      _state.render(() => _state.bkUsers = results);
      print(_state.bkUsers);
    }

    /*Navigator.pushNamed(_state.context, PostReviewScreen.routeName, arguments: {
      'user': _state.user,
      'bkUser': _state.bkUser,
      'bkUsers': results,
    });*/
  }

  void follow(int index) async {
    _state.render(() {
      if (!_state.bkUser.following.contains(_state.bkUsers[index].user)) {
        _state.bkUser.following.add(_state.bkUsers[index].user);
      }
    });

    try {
      await FirebaseController.updateFollowing(_state.bkUser);
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
      if (_state.bkUser.following.contains(_state.bkUsers[index].user)) {
        _state.bkUser.following.remove(_state.bkUsers[index].user);
      }
    });
    try {
      await FirebaseController.updateFollowing(_state.bkUser);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error occured, could not unfollow user',
        content: e.message ?? e.toString(),
      );
    }
  }

  void goToProfile(int index) {}
}
