import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/screen/library_screen.dart';
import 'package:bookkeeperapp/screen/shop_screen.dart';
import 'package:bookkeeperapp/screen/signin_screen.dart';
import 'package:bookkeeperapp/screen/views/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/signInScreen/homeScreen';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  User user;
  _Controller con;
  var formKey = GlobalKey<FormState>();
  int currentIndex = 0;

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
        title: Text('Home'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: con.newPost,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'Post Update',
                child: Row(
                  children: <Widget>[Icon(Icons.edit), Text(' Post Update')],
                ),
              ),
              PopupMenuItem(
                value: 'Post Review',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.collections_bookmark),
                    Text(' Post Review')
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Text('Home'),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: Colors.orange[50],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: con.onItemTapped,
        items: [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Library'),
            icon: Icon(Icons.book),
          ),
          BottomNavigationBarItem(
            title: Text('Store'),
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _HomeState _state;
  _Controller(this._state);

  void settings() async {
    /*await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
        arguments: _state.user);*/

    // to get updated user profile do the following 2 steps
    /*await _state.user.reload();
    _state.user = await FirebaseAuth.instance.currentUser();*/

    Navigator.pop(_state.context); // close drawer
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      print('sign out exception: ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void newPost(String src) async {
    try {
      if (src == 'Post Update') {
      } else {}
    } catch (e) {}
  }

  void onItemTapped(int index) {
    _state.render(() {
      _state.currentIndex = index;
    });
    if (_state.currentIndex == 1) {
      Navigator.pushNamed(_state.context, LibraryScreen.routeName,
          arguments: {'user': _state.user});
    } else if (_state.currentIndex == 2) {
      Navigator.pushNamed(_state.context, ShopScreen.routeName,
          arguments: {'user': _state.user});
    } else if (_state.currentIndex == 3) {
      Navigator.pushNamed(_state.context, ProfileScreen.routeName,
          arguments: {'user': _state.user});
    }
  }
}
