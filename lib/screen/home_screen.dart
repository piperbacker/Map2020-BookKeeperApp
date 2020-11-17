import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/librar_screen.dart';
import 'package:bookkeeperapp/screen/postupdate_screen.dart';
import 'package:bookkeeperapp/screen/reviewbooksearch_screen.dart';
import 'package:bookkeeperapp/screen/shop_screen.dart';
import 'package:bookkeeperapp/screen/userprofile_screen.dart';
import 'package:bookkeeperapp/screen/usersearch_screen.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:bookkeeperapp/screen/myprofile_screen.dart';
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
  List<BKPost> homeFeed;
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
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    bkUser ??= args['bkUser'];
    bkPosts ??= args['bkPosts'];
    homeFeed ??= args['homeFeed'];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
              width: 170.0,
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
        body: RefreshIndicator(
          onRefresh: con.refreshHome,
          child: homeFeed.length == 0
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
                    itemCount: homeFeed.length,
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
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: Row(
                                  children: [
                                    /*Container(
                                    height: 60,
                                    width: 60,
                                    child: ClipOval(
                                      child: MyImageView.network(
                                          imageURL: homeFeed[index].postedBy,
                                          context: context),
                                    ),
                                  ),*/
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    FlatButton(
                                      onPressed: () => con.goToProfile(index),
                                      child: Text(
                                        homeFeed[index].displayName,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.cyan[900],
                                        ),
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
                                  homeFeed[index].title,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Divider(height: 30.0, color: Colors.orangeAccent),
                              Text(
                                homeFeed[index].body,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              homeFeed[index].photoURL == null
                                  ? SizedBox(height: 1)
                                  : Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 5.0, 10.0, 5.0),
                                      child: MyImageView.network(
                                          imageURL: homeFeed[index].photoURL,
                                          context: context),
                                    ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  homeFeed[index].postedBy == bkUser.email
                                      ? SizedBox(
                                          height: 1.0,
                                        )
                                      : Row(
                                          children: <Widget>[
                                            !homeFeed[index]
                                                    .likedBy
                                                    .contains(bkUser.email)
                                                ? IconButton(
                                                    icon: Icon(
                                                        Icons.favorite_border),
                                                    onPressed: () =>
                                                        con.like(index),
                                                  )
                                                : IconButton(
                                                    icon: Icon(Icons.favorite),
                                                    color: Colors.pink,
                                                    onPressed: () =>
                                                        con.unlike(index),
                                                  ),
                                          ],
                                        ),
                                  homeFeed[index].likedBy.length == 0
                                      ? SizedBox(
                                          height: 1.0,
                                        )
                                      : Flexible(
                                          child: Text(
                                            '${homeFeed[index].likedBy.length} likes',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
  String searchKey;
  //List<BKPost> homeFeed;

  Future<void> refreshHome() async {
    Future.delayed(Duration(seconds: 3));

    List<dynamic> following = _state.bkUser.following;
    // to ensure own user's posts are shown on home feed
    following.add(_state.bkUser.email);

    // get user's home feed
    _state.homeFeed = await FirebaseController.getHomeFeed(following);
    following.remove(_state.bkUser.email);

    _state.render(() {});
  }

  void onSavedSearchKey(String value) {
    searchKey = value;
  }

  void search() async {
    _state.formKey.currentState.save();

    var results;
    if (searchKey == null || searchKey.trim().isEmpty) {
      return;
    } else {
      results = await FirebaseController.searchUsers(displayName: searchKey);
      //print(results);

      await Navigator.pushNamed(_state.context, UserSearchScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'results': results,
          });
      _state.render(() {
        FocusScope.of(_state.context).requestFocus(FocusNode());
      });
    }
  }

  void newPost(String src) async {
    try {
      if (src == 'Post Update') {
        await Navigator.pushNamed(_state.context, PostUpdateScreen.routeName,
            arguments: {
              'user': _state.user,
              'bkUser': _state.bkUser,
              'bkPosts': _state.bkPosts,
              'homeFeed': _state.homeFeed,
            });
        _state.render(() {});
      } else {
        List<BKBook> bkBooks = await FirebaseController.getBKBooks();
        await Navigator.pushNamed(
            _state.context, ReviewBookSearchScreen.routeName,
            arguments: {
              'user': _state.user,
              'bkUser': _state.bkUser,
              'bkPosts': _state.bkPosts,
              'homeFeed': _state.homeFeed,
              'bkBooks': bkBooks,
            });
        _state.render(() {});
      }
    } catch (e) {}
  }

  void goToProfile(int index) async {
    // get user's info
    List<BKUser> bkUserList =
        await FirebaseController.getBKUser(_state.homeFeed[index].postedBy);
    BKUser userProfile = bkUserList[0];

    // get list of user's posts
    List<BKPost> userPosts =
        await FirebaseController.getBKPosts(_state.homeFeed[index].postedBy);

    if (_state.homeFeed[index].postedBy == _state.bkUser.email) {
      Navigator.pushNamed(_state.context, MyProfileScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'bkPosts': userPosts,
          });
    } else {
      Navigator.pushNamed(_state.context, UserProfileScreen.routeName,
          arguments: {
            'bkUser': _state.bkUser,
            'userPosts': userPosts,
            'userProfile': userProfile,
          });
    }
  }

  void like(int index) async {
    _state.render(() {
      if (!_state.homeFeed[index].likedBy.contains(_state.user.email)) {
        _state.homeFeed[index].likedBy.add(_state.user.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.homeFeed[index]);
    } catch (e) {}
  }

  void unlike(int index) async {
    _state.render(() {
      if (_state.homeFeed[index].likedBy.contains(_state.user.email)) {
        _state.homeFeed[index].likedBy.remove(_state.user.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.homeFeed[index]);
    } catch (e) {}
  }

  void onItemTapped(int index) async {
    _state.render(() {
      _state.currentIndex = index;
    });

    if (_state.currentIndex == 1) {
      Navigator.pushNamed(_state.context, LibraryScreen.routeName, arguments: {
        'user': _state.user,
        'bkUser': _state.bkUser,
        //'bkBooks': bkBooks,
      });
    } else if (_state.currentIndex == 2) {
      // get bkBooks
      List<BKBook> bkBooks = await FirebaseController.getBKBooks();
      Navigator.pushNamed(_state.context, ShopScreen.routeName, arguments: {
        'user': _state.user,
        'bkUser': _state.bkUser,
        'bkBooks': bkBooks,
      });
    } else if (_state.currentIndex == 3) {
      await Navigator.pushNamed(_state.context, MyProfileScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'bkPosts': _state.bkPosts,
          });
      _state.render(() {});
    }
  }
}
