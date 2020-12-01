import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthorMetricsScreen extends StatefulWidget {
  static const routeName = 'home/authorMetricsScreen';

  @override
  State<StatefulWidget> createState() {
    return _AuthorMetricsState();
  }
}

class _AuthorMetricsState extends State<AuthorMetricsScreen> {
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
        title: Text('Author Stats'),
      ),
      body: Text('metrics'),
    );
  }
}

class _Controller {
  _AuthorMetricsState _state;
  _Controller(this._state);
}
