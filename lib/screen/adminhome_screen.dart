import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/createnewaccount_screen.dart';
import 'package:bookkeeperapp/screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'changepassword_screen.dart';
import 'managestore_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  static const routeName = '/AdminHomeScreen';

  @override
  State<StatefulWidget> createState() {
    return _AdminHomeState();
  }
}

class _AdminHomeState extends State<AdminHomeScreen> {
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
        title: Text('Admin Home'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.book),
            title: Text(
              'Manage Book Store',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            onTap: con.manageBookStore,
          ),
          Divider(height: 10.0, thickness: 2.0, color: Colors.orange[50]),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Create New User Account',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            onTap: con.createNewUser,
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
  _AdminHomeState _state;
  _Controller(this._state);

  void manageBookStore() {
    // add firebase to get books

    Navigator.pushNamed(
      _state.context,
      ManageStoreScreen.routeName,
    );
  }

  void createNewUser() {
    Navigator.pushNamed(
      _state.context,
      CreateNewAccountScreen.routeName,
    );
  }

  void changePassword() async {
    await Navigator.pushNamed(_state.context, ChangePasswordScreen.routeName,
        arguments: _state.user);
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
