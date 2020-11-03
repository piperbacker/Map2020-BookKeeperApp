import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostUpdateScreen extends StatefulWidget {
  static const routeName = 'home/postUpdateScreen';

  @override
  State<StatefulWidget> createState() {
    return _PostUpdateState();
  }
}

class _PostUpdateState extends State<PostUpdateScreen> {
  User user;
  BKUser bkUser;
  List<BKPost> bkPosts;
  var formKey = GlobalKey<FormState>();
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
    bkPosts ??= args['bkPosts'];

    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
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
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                      style: TextStyle(fontSize: 30.0, color: Colors.cyan[900]),
                      autocorrect: true,
                      validator: con.validatorTitle,
                      onSaved: con.onSavedTitle,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Write your update here...',
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      autocorrect: true,
                      validator: con.validatorMemo,
                      onSaved: con.onSavedMemo,
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
  _PostUpdateState _state;
  _Controller(this._state);
  String title;
  String body;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);

      var p = BKPost(
        title: title,
        body: body,
        postedBy: _state.user.email,
        displayName: _state.user.displayName,
        updatedAt: DateTime.now(),
      );

      p.docId = await FirebaseController.addPost(p);
      _state.bkPosts.insert(0, p);

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

  String validatorTitle(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedTitle(String value) {
    title = value;
  }

  String validatorMemo(String value) {
    if (value == null || value.trim().length < 3) {
      return 'min 3 chars';
    } else {
      return null;
    }
  }

  void onSavedMemo(String value) {
    body = value;
  }
}
