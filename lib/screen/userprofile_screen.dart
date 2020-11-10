import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    userProfile ??= args['userProfile'];
    bkPosts ??= args['bkPosts'];

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
                            imageURL: userProfile.photoURL, context: context),
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
                        userProfile.displayName,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.cyan[900],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      userProfile.userBio == null
                          ? Container()
                          : Text(
                              userProfile.userBio,
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
                                                imageURL: userProfile.photoURL,
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
                                  bkPosts[index].photoURL == null
                                      ? SizedBox(height: 1)
                                      : Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10.0, 5.0, 10.0, 5.0),
                                          child: MyImageView.network(
                                              imageURL: bkPosts[index].photoURL,
                                              context: context),
                                        ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  !bkPosts[index].likedBy.contains(user.email)
                                      ? IconButton(
                                          icon: Icon(Icons.favorite_border),
                                          onPressed: () => con.like(index),
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.favorite),
                                          color: Colors.pink,
                                          onPressed: () => con.unlike(index),
                                        ),
                                  bkPosts[index].likedBy.length == 0
                                      ? SizedBox(
                                          height: 1.0,
                                        )
                                      : Flexible(
                                          child: Text(
                                            '${bkPosts[index].likedBy.length} likes',
                                            //overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
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
    );
  }
}

class _Controller {
  _UserProfileState _state;
  _Controller(this._state);

  void like(int index) async {
    _state.render(() {
      if (!_state.bkPosts[index].likedBy.contains(_state.user.email)) {
        _state.bkPosts[index].likedBy.add(_state.user.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.bkPosts[index]);
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
      if (_state.bkPosts[index].likedBy.contains(_state.user.email)) {
        _state.bkPosts[index].likedBy.remove(_state.user.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.bkPosts[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Unlike photo memo error in saving',
        content: e.message ?? e.toString(),
      );
    }
  }
}
