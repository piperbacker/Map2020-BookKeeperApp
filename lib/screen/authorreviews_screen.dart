import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthorReviewsScreen extends StatefulWidget {
  static const routeName = '/authorReviewsScreen';

  @override
  State<StatefulWidget> createState() {
    return _AuthorReviewsState();
  }
}

class _AuthorReviewsState extends State<AuthorReviewsScreen> {
  BKUser bkUser;
  BKBook bkBook;
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
    bkUser ??= args['bkUser'];
    bkBook ??= args['bkBook'];

    return Scaffold(
      appBar: AppBar(
        title: Text('AuthorReviews'),
      ),
      body: Text("AuthorReviews"),
    );
  }
}

class _Controller {
  _AuthorReviewsState _state;
  _Controller(this._state);
}
