import 'package:bookkeeperapp/model/bkuser.dart';
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
  BKUser bKUser;
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
    bKUser ??= args['bKUser'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Review'),
      ),
      body: Text("Post Review"),
    );
  }
}

class _Controller {
  _PostUpdateState _state;
  _Controller(this._state);
}
