import 'dart:math';

import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/signin_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:flutter/material.dart';

enum UserTag { author, admin }

class CreateNewAccountScreen extends StatefulWidget {
  static const routeName = '/createNewAccountScreen';
  @override
  State<StatefulWidget> createState() {
    return _CreateNewAccountState();
  }
}

class _CreateNewAccountState extends State<CreateNewAccountScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  // List<BKUser> users;
  UserTag userTag = UserTag.author;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New User Account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'User Display Name',
                  ),
                  autocorrect: false,
                  validator: con.validatorDisplayName,
                  onSaved: con.onSavedDisplayName,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'User Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: con.validatorEmail,
                  onSaved: con.onSavedEmail,
                ),
              ),
              /*Container(
                margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'DPassword',
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validatorPassword,
                  onSaved: con.onSavedPassword,
                ),
              ),*/
              Column(
                children: <Widget>[
                  RadioListTile<UserTag>(
                    activeColor: Colors.orange[300],
                    title: const Text(
                      'Author User',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    value: UserTag.author,
                    groupValue: userTag,
                    onChanged: (UserTag value) {
                      render(() {
                        userTag = value;
                      });
                    },
                  ),
                  RadioListTile<UserTag>(
                    activeColor: Colors.orange[300],
                    title: const Text(
                      'Admin User',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    value: UserTag.admin,
                    groupValue: userTag,
                    onChanged: (UserTag value) {
                      render(() {
                        userTag = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              ButtonTheme(
                minWidth: 150.0,
                height: 50.0,
                child: RaisedButton(
                  child: Text(
                    'Create',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  color: Colors.teal[400],
                  onPressed: con.createNewAccount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _CreateNewAccountState _state;
  _Controller(this._state);
  String email;
  String displayName;
  static final validCharacters = RegExp(r'^[a-zA-Z ]+$');

  void createNewAccount() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      Random random = new Random();
      var password;
      for (var i = 0; i < 9; i++) {
        password += random.nextInt(100);
        password = password.toString();
        print(password);
      }
      var p = BKUser(
        email: email,
        displayName: displayName,
        userTag: _state.userTag.toString(),
      );

      p.docId = await FirebaseController.createNewUserAccount(
        email,
        password,
        p,
      );

      MyDialog.info(
        context: _state.context,
        title: 'Successfully Created',
        content: 'Email has been sent to user with login credentials',
      );

      //Navigator.pushNamed(_state.context, SignInScreen.routeName);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorEmail(String value) {
    if (value == null || !value.contains('@') || !value.contains('.')) {
      return ('Invalid Email Adress');
    } else {
      return null;
    }
  }

  void onSavedEmail(String value) {
    this.email = value;
  }

  /*String validatorPassword(String value) {
    if (value == null || value.length < 6) {
      return ('Password min 6 chars');
    } else {
      return null;
    }
  }

  void onSavedPassword(String value) {
    this.password = value;
  }*/

  String validatorDisplayName(String value) {
    if (value == null || value.length < 2 || !validCharacters.hasMatch(value)) {
      return ('Min 2 chars, can only contain alpahabet symbols and spaces');
    } else {
      return null;
    }
  }

  void onSavedDisplayName(String value) {
    this.displayName = value;
  }
}
