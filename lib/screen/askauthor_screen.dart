import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AskAuthorScreen extends StatefulWidget {
  static const routeName = '/userProfile/askAuthorScreen';

  @override
  State<StatefulWidget> createState() {
    return _AskAuthorState();
  }
}

class _AskAuthorState extends State<AskAuthorScreen> {
  User user;
  BKUser bkUser;
  BKUser authorProfile;
  _Controller con;
  var formKey = GlobalKey<FormState>();

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
    authorProfile ??= args['authorProfile'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ask the Author'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: con.send,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                color: Colors.orange[50],
                height: 600,
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    'Ask ${authorProfile.displayName} A Question',
                    style: TextStyle(fontSize: 23.0, color: Colors.cyan[900]),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'your question here...',
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: con.validatorQuestion,
                      onSaved: con.onSavedQuestion,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AskAuthorState _state;
  _Controller(this._state);
  String question;

  void send() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      var p;
      MyDialog.circularProgressStart(_state.context);

      p = BKPost(
        postedBy: _state.authorProfile.email,
        question: question,
        asking: _state.bkUser.displayName,
        answered: false,
      );

      p.docId = await FirebaseController.addPost(p);

      MyDialog.circularProgressEnd(_state.context);

      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);

      MyDialog.info(
        context: _state.context,
        title: 'Firebase Error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorQuestion(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedQuestion(String value) {
    question = value;
  }
}
