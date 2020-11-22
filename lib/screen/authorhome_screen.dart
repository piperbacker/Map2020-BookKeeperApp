import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/authoranswer_screen.dart';
import 'package:bookkeeperapp/screen/postupdate_screen.dart';
import 'package:bookkeeperapp/screen/authorbooks_screen.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/myprofile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthorHomeScreen extends StatefulWidget {
  static const routeName = '/signInScreen/authorHomeScreen';

  @override
  State<StatefulWidget> createState() {
    return _AuthorHomeState();
  }
}

class _AuthorHomeState extends State<AuthorHomeScreen> {
  User user;
  BKUser bkUser;
  List<BKPost> bkPosts;
  List<BKPost> questions;
  _Controller con;
  //var formKey = GlobalKey<FormState>();
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
    questions ??= args['questions'];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Author Questions'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: con.postUpdate,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: con.refreshHome,
          child: questions.length == 0
              ? Center(
                  child: Text(
                    'There are no questions to answer currently',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.cyan[900],
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: ListView.builder(
                    itemCount: questions.length,
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
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      questions[index].asking,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.cyan[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: Text(
                                  questions[index].question,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Divider(height: 30.0, color: Colors.orangeAccent),
                              Container(
                                alignment: Alignment(1.0, 1.0),
                                child: IconButton(
                                  icon: Icon(Icons.question_answer),
                                  onPressed: () => con.respond(index),
                                ),
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
              title: Text('Reviews'),
              icon: Icon(Icons.book),
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
  _AuthorHomeState _state;
  _Controller(this._state);
  String searchKey;
  String answer;
  Future<void> refreshHome() async {
    Future.delayed(Duration(seconds: 3));

    // get user's home feed
    _state.questions =
        await FirebaseController.getAuthorQuestions(_state.bkUser.email);

    _state.render(() {});
  }

  void postUpdate() async {
    await Navigator.pushNamed(_state.context, PostUpdateScreen.routeName,
        arguments: {
          'user': _state.user,
          'bkUser': _state.bkUser,
          'bkPosts': _state.bkPosts,
          'homeFeed': null,
        });
    _state.render(() {});
  }

  void respond(int index) async {
    await Navigator.pushNamed(_state.context, AuthorAnswerScreen.routeName,
        arguments: {
          'user': _state.user,
          'bkUser': _state.bkUser,
          'bkPosts': _state.bkPosts,
          'question': _state.questions[index],
        });

    _state.questions =
        await FirebaseController.getAuthorQuestions(_state.bkUser.email);

    _state.render(() {});
  }

  void onItemTapped(int index) async {
    _state.render(() {
      _state.currentIndex = index;
    });

    if (_state.currentIndex == 1) {
      // get author's books
      List<BKBook> authorBooks =
          await FirebaseController.getAuthorBooks(_state.bkUser);
      await Navigator.pushNamed(_state.context, AuthorBooksScreen.routeName,
          arguments: {
            'user': _state.user,
            'bkUser': _state.bkUser,
            'bkBooks': authorBooks,
          });
    }

    if (_state.currentIndex == 2) {
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
