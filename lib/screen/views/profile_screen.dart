import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileScreen> {
  User user;
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //MyImageView.network.imageURL
            Center(
              child: CircleAvatar(
                child: MyImageView.network(
                    imageURL: user.photoURL, context: context),
                radius: 60.0,
              ),
            ),
            /*Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/def_profile.png'),
                radius: 70.0,
              ),
            ),*/
            SizedBox(
              height: 40.0,
            ),
            Text(
              user.displayName,
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            Divider(height: 50.0, color: Colors.orangeAccent),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _ProfileState _state;
  _Controller(this._state);

  void settings() {
    Navigator.pushNamed(_state.context, SettingsScreen.routeName,
        arguments: {'user': _state.user});
  }
}
