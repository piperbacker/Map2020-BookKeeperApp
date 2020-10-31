import 'package:bookkeeperapp/screen/editprofile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/profileScreen/settingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
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
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            //leading: Icon(Icons.people),
            title: Text('Edit Profile'),
            onTap: con.editProfile,
          ),
          ListTile(
            //leading: Icon(Icons.settings),
            title: Text('Change Password'),
            onTap: con.changePassword,
          ),
          Center(child: Text('Sign Out')),
        ],
      ),
    );
  }
}

class _Controller {
  _SettingsState _state;
  _Controller(this._state);

  void editProfile() {
    Navigator.pushNamed(_state.context, EditProfileScreen.routeName,
        arguments: {'user': _state.user});
  }

  void changePassword() {}
}
