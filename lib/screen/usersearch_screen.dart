import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSearchScreen extends StatefulWidget {
  static const routeName = 'home/userSearchScreen';

  @override
  State<StatefulWidget> createState() {
    return _UserSearchState();
  }
}

class _UserSearchState extends State<UserSearchScreen> {
  User user;
  _Controller con;
  BKUser bkUser;
  List<BKPost> bkPosts;
  List<BKUser> bkUsers;
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
    bkUsers ??= args['bkUsers'];

    return Scaffold(
      appBar: AppBar(
        title: Text('User Search'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
            width: 160.0,
            child: Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Users',
                  fillColor: Colors.white,
                  filled: true,
                ),
                autocorrect: false,
                onSaved: con.onSavedSearchKey,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: con.search,
          ),
        ],
      ),
      body: Text("Search"),
    );
  }
}

class _Controller {
  _UserSearchState _state;
  _Controller(this._state);

  String searchKey;

  void onSavedSearchKey(String value) {
    searchKey = value;
  }

  void search() async {
    _state.formKey.currentState.save();

    var results;
    if (searchKey == null || searchKey.trim().isEmpty) {
      Navigator.pushNamed(_state.context, HomeScreen.routeName,
          arguments: {'user': _state.user, 'bkUser': _state.bkUser});
    } else {
      results = await FirebaseController.searchUsers(displayName: searchKey);
    }

    _state.render(() => _state.bkUsers = results);
    print(_state.bkUsers);

    /*Navigator.pushNamed(_state.context, PostReviewScreen.routeName, arguments: {
      'user': _state.user,
      'bkUser': _state.bkUser,
      'bkUsers': results,
    });*/
  }
}
