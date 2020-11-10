import 'package:bookkeeperapp/screen/signin_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/settingsScreen/changePasswordScreen';
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  User user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    user ??= ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
              child: TextFormField(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter New Password',
                ),
                obscureText: true,
                autocorrect: false,
                initialValue: null,
                validator: con.validatorPassword,
                onSaved: con.onSavedPassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _ChangePasswordState _state;
  _Controller(this._state);
  String password;

  void save() {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      User user = FirebaseAuth.instance.currentUser;
      user.updatePassword(password);

      Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Change password error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorPassword(String value) {
    if (value == null || value.length < 6) {
      return ('Password min 6 chars');
    } else {
      return null;
    }
  }

  void onSavedPassword(String value) {
    this.password = value;
  }
}
