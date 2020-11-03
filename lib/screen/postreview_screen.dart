import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostReviewScreen extends StatefulWidget {
  static const routeName = 'home/postReviewScreen';

  @override
  State<StatefulWidget> createState() {
    return _PostReviewState();
  }
}

class _PostReviewState extends State<PostReviewScreen> {
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
        title: Text('Post Review'),
      ),
      body: Text("Post Review"),
    );
  }
}

class _Controller {
  _PostReviewState _state;
  _Controller(this._state);
}
