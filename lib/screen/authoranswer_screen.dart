import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthorAnswerScreen extends StatefulWidget {
  static const routeName = 'home/authorAnswerScreen';

  @override
  State<StatefulWidget> createState() {
    return _AuthorAnswerState();
  }
}

class _AuthorAnswerState extends State<AuthorAnswerScreen> {
  User user;
  List<BKPost> bkPosts;
  BKUser bkUser;
  BKPost question;
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
    bkPosts ??= args['bkPosts'];
    question ??= args['question'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Answer ${question.asking}'s Question"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.respond,
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
                    '${question.asking} Asks...',
                    style: TextStyle(fontSize: 23.0, color: Colors.cyan[900]),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: Text('${question.question}',
                        style: TextStyle(fontSize: 20.0)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'your answer here...',
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: con.validatorAnswer,
                      onSaved: con.onSavedAnswer,
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
  _AuthorAnswerState _state;
  _Controller(this._state);
  String answer;

  void respond() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);
      _state.question.body = answer;
      _state.question.answered = true;
      _state.question.displayName = _state.bkUser.displayName;

      await FirebaseController.updateAuthorQuestion(_state.question);
      _state.bkPosts.insert(0, _state.question);

      MyDialog.circularProgressEnd(_state.context);

      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);

      MyDialog.info(
        context: _state.context,
        title: 'Edit Book error in saving',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorAnswer(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedAnswer(String value) {
    answer = value;
  }
}
