import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/library_screen.dart';
import 'package:bookkeeperapp/screen/postreview_screen.dart';
import 'package:bookkeeperapp/screen/postupdate_screen.dart';
import 'package:bookkeeperapp/screen/shop_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
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
  BKUser bkUser;
  List<BKPost> bkPosts;
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
    bkUser ??= arg['bkUser'];
    bkPosts ??= arg['bkPosts'];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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
        body: bkPosts.length == 0
            ? Center(
                child: Text(
                  'Home Feed is Empty',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.cyan[900],
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: ListView.builder(
                  itemCount: bkPosts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.orange[50],
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    child: ClipOval(
                                      child: MyImageView.network(
                                          imageURL: user.photoURL,
                                          context: context),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    bkPosts[index].displayName,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.cyan[900],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Center(
                              child: Text(
                                bkPosts[index].title,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Divider(height: 30.0, color: Colors.orangeAccent),
                            Text(
                              bkPosts[index].body,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            bkPosts[index].postedBy == user.email
                                ? SizedBox(
                                    height: 1.0,
                                  )
                                : Row(
                                    children: <Widget>[
                                      !bkPosts[index]
                                              .likedBy
                                              .contains(user.email)
                                          ? IconButton(
                                              icon: Icon(Icons.favorite_border),
                                              onPressed: () => con.like(index),
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.favorite),
                                              color: Colors.pink,
                                              onPressed: () =>
                                                  con.unlike(index),
                                            ),
                                      bkPosts[index].likedBy.length == 0
                                          ? SizedBox(
                                              height: 1.0,
                                            )
                                          : Flexible(
                                              child: Text(
                                                'Liked By: ${bkPosts[index].likedBy.toString()}',
                                                overflow: TextOverflow.visible,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                          ],
                        ),
                        //onTap: () => con.onTap(index),
                        //onLongPress: () => con.onLongPress(index),
                      ),
                    );
                  },
                ),
              ),
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
      ),
    );
  }
}

class _Controller {
  _HomeState _state;
  _Controller(this._state);

  void newPost(String src) async {
    try {
      if (src == 'Post Update') {
        await Navigator.pushNamed(_state.context, PostUpdateScreen.routeName,
            arguments: {
              'user': _state.user,
              'bkUser': _state.bkUser,
              'bkPosts': _state.bkPosts,
            });
        _state.render(() {});
      } else {
        Navigator.pushNamed(_state.context, PostReviewScreen.routeName,
            arguments: {
              'user': _state.user,
              'bkUser': _state.bkUser,
              'bkPosts': _state.bkPosts,
            });
      }
    } catch (e) {}
  }

  void like(int index) async {
    _state.render(() {
      if (!_state.bkPosts[index].likedBy.contains(_state.user.email)) {
        _state.bkPosts[index].likedBy.add(_state.user.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.bkPosts[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Like photo memo error in saving',
        content: e.message ?? e.toString(),
      );
    }
  }

  void unlike(int index) async {
    _state.render(() {
      if (_state.bkPosts[index].likedBy.contains(_state.user.email)) {
        _state.bkPosts[index].likedBy.remove(_state.user.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.bkPosts[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Unlike photo memo error in saving',
        content: e.message ?? e.toString(),
      );
    }
  }

  void onItemTapped(int index) {
    _state.render(() {
      _state.currentIndex = index;
    });
    if (_state.currentIndex == 1) {
      Navigator.pushNamed(_state.context, LibraryScreen.routeName,
          arguments: {'user': _state.user, 'bkUser': _state.bkUser});
    } else if (_state.currentIndex == 2) {
      Navigator.pushNamed(_state.context, ShopScreen.routeName,
          arguments: {'user': _state.user, 'bkUser': _state.bkUser});
    } else if (_state.currentIndex == 3) {
      Navigator.pushNamed(_state.context, ProfileScreen.routeName, arguments: {
        'user': _state.user,
        'bkUser': _state.bkUser,
        'bkPosts': _state.bkPosts,
      });
    }
  }
}
