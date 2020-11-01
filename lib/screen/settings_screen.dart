import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/editprofile_screen.dart';
import 'package:bookkeeperapp/screen/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'changepassword_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/profileScreen/settingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
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
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    bkUser ??= arg['bkUser'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            onTap: con.editProfile,
          ),
          Divider(height: 10.0, thickness: 2.0, color: Colors.orange[50]),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text(
              'Change Password',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            onTap: con.changePassword,
          ),
          Divider(height: 10.0, thickness: 2.0, color: Colors.orange[50]),
          SizedBox(
            height: 40.0,
          ),
          Center(
            child: FlatButton(
              onPressed: con.signOut,
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.cyan[900],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _SettingsState _state;
  _Controller(this._state);

  void editProfile() async {
    await Navigator.pushNamed(_state.context, EditProfileScreen.routeName,
        arguments: {'user': _state.user, 'bkUser': _state.bkUser});

    // to get updated user profile do the following 2 steps

    _state.render(() {
      _state.user.reload();
      _state.user = FirebaseAuth.instance.currentUser;
    });
    Navigator.pop(_state.context);
  }

  void changePassword() async {
    await Navigator.pushNamed(_state.context, ChangePasswordScreen.routeName,
        arguments: _state.user);

    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      print('sign out exception: ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }
}
