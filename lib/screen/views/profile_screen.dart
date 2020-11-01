import 'package:bookkeeperapp/model/bkuser.dart';
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
  BKUser bkUser;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //MyImageView.network.imageURL
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  child: ClipOval(
                    child: MyImageView.network(
                        imageURL: user.photoURL, context: context),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                user.displayName,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              SizedBox(
                height: 20.0,
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
        ),
      ),
    );
  }
}

class _Controller {
  _ProfileState _state;
  _Controller(this._state);

  void settings() {
    //print(_state.bkUser);
    Navigator.pushNamed(_state.context, SettingsScreen.routeName,
        arguments: {'user': _state.user, 'bkUser': _state.bkUser});

    /*_state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;*/
  }
}
