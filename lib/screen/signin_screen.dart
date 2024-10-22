import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/adminhome_screen.dart';
import 'package:bookkeeperapp/screen/signup_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authorhome_screen.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Sign In'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Image.asset(
                  'assets/images/app_icon.png',
                  height: 130.0,
                ),
                Text(
                  'Book Keeper',
                  style: TextStyle(
                    fontSize: 25.0,
                    //fontFamily: 'Audiowide'
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: con.validatorEmail,
                    onSaved: con.onSavedEmail,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: con.validatorPassword,
                    onSaved: con.onSavedPassword,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                ButtonTheme(
                  minWidth: 150.0,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.teal[400],
                    onPressed: con.signIn,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton(
                  onPressed: con.signUp,
                  child: Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 15.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignInState _state;
  _Controller(this._state);
  String email;
  String password;

  void signUp() async {
    Navigator.pushNamed(_state.context, SignUpScreen.routeName);
  }

  void signIn() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();

    MyDialog.circularProgressStart(_state.context);

    User user;
    try {
      user = await FirebaseController.signIn(email, password);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Sign In Error',
        content: e.message ?? e.toString(),
      );
      return;
    }

    // get user's info
    List<BKUser> bkUserList = await FirebaseController.getBKUser(user.email);
    BKUser bkUser = bkUserList[0];

    // get user's posts
    List<BKPost> bkPosts = await FirebaseController.getBKPosts(bkUser.email);

    if (bkUser.userTag == 'reader') {
      List<dynamic> following = bkUser.following;
      // to ensure own user's posts are shown on home feed
      following.add(bkUser.email);
      // get user's home feed
      List<BKPost> homeFeed = await FirebaseController.getHomeFeed(following);
      following.remove(bkUser.email);

      Navigator.pushReplacementNamed(_state.context, HomeScreen.routeName,
          arguments: {
            'user': user,
            'bkUser': bkUser,
            'bkPosts': bkPosts,
            'homeFeed': homeFeed,
          });
    }

    if (bkUser.userTag == 'admin') {
      Navigator.pushReplacementNamed(_state.context, AdminHomeScreen.routeName,
          arguments: {
            'user': user,
            'bkUser': bkUser,
          });
    }

    if (bkUser.userTag == 'author') {
      List<BKPost> questions =
          await FirebaseController.getAuthorQuestions(bkUser.email);

      Navigator.pushReplacementNamed(_state.context, AuthorHomeScreen.routeName,
          arguments: {
            'user': user,
            'bkUser': bkUser,
            'bkPosts': bkPosts,
            'questions': questions,
          });
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
    email = value;
  }

  String validatorPassword(String value) {
    if (value == null || value.length < 6) {
      return ('Password min 6 chars');
    } else {
      return null;
    }
  }

  void onSavedPassword(String value) {
    password = value;
  }
}
