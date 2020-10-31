import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/screen/signin_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signInScreen/signUpScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Account'),
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
                    hintText: 'Display Name',
                  ),

                  ///keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: con.validatorDisplayName,
                  onSaved: con.onSavedDisplayName,
                ),
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
                    'Create',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  color: Colors.teal[400],
                  onPressed: con.signUp,
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
  _SignUpState _state;
  _Controller(this._state);
  String email;
  String password;
  String displayName;
  static final validCharacters = RegExp(r'^[a-zA-Z ]+$');

  void signUp() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      await FirebaseController.signUp(displayName, email, password);
      MyDialog.info(
        context: _state.context,
        title: 'Succesfully Created',
        content: 'Your account is created! Go to Sign In',
      );
      Navigator.pushNamed(_state.context, SignInScreen.routeName);
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
