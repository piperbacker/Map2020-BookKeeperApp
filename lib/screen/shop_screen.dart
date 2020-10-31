import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shopScreen';

  @override
  State<StatefulWidget> createState() {
    return _ShopState();
  }
}

class _ShopState extends State<ShopScreen> {
  User user;
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: Text("Shop"),
    );
  }
}

class _Controller {
  _ShopState _state;
  _Controller(this._state);
}
