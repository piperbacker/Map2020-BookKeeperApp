import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../settings_screen.dart';

class MyProfileScreen extends StatefulWidget {
  static const routeName = 'home/myProfileScreen';

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
        // "${user.displayName}'s Profile"
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 30.0,
            onPressed: con.settings,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: ClipOval(
                        child: MyImageView.network(
                            imageURL: user.photoURL, context: context),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        user.displayName,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.cyan[900],
                        ),
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
                      Divider(height: 50.0, color: Colors.orangeAccent),
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
                : Expanded(
                    //height: 200.0,
                    child: ListView.builder(
                      itemCount: bkPosts.length,
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
                                                imageURL: user.photoURL,
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
                                      : Flexible(
                                          child: Text(
                                            'Liked By: ${bkPosts[index].likedBy.toString()}',
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              //onTap: () => con.onTap(index),
                              //onLongPress: () => con.onLongPress(index),
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
  _MyProfileState _state;
  _Controller(this._state);

  void settings() async {
    await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
        arguments: {'user': _state.user, 'bkUser': _state.bkUser});

    await _state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;
    _state.render(() {});
  }
}
