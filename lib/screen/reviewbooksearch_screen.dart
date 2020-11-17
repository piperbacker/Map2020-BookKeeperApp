import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/postreview_screen.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:flutter/material.dart';

class ReviewBookSearchScreen extends StatefulWidget {
  static const routeName = 'home/reviewBookSearchScreen';

  @override
  State<StatefulWidget> createState() {
    return _ReviewBookSearchState();
  }
}

class _ReviewBookSearchState extends State<ReviewBookSearchScreen> {
  BKUser bkUser;
  List<BKBook> bkBooks;
  List<BKPost> bkPosts;
  List<BKPost> homeFeed;
  _Controller con;
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
    bkUser ??= args['bkUser'];
    bkPosts ??= args['bkPosts'];
    homeFeed ??= args['homeFeed'];
    bkBooks ??= args['bkBooks'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Selection'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Text("Which book would you like to review?",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.cyan[900],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                width: 200.0,
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search Book Titles',
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
          Divider(height: 50.0, color: Colors.orangeAccent),
          SizedBox(
            height: 20.0,
          ),
          bkBooks.length == 0
              ? Center(
                  child: Text(
                    'There are no results matching your query',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.cyan[900],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: bkBooks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 100.0,
                              margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              child: MyImageView.network(
                                  imageURL: bkBooks[index].photoURL,
                                  context: context),
                            ),
                            Column(
                              children: [
                                Text(
                                  bkBooks[index].title,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  bkBooks[index].author,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.cyan[900],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20.0),
                            IconButton(
                              iconSize: 50.0,
                              icon: Icon(Icons.arrow_right),
                              onPressed: () => con.selectBook(index),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class _Controller {
  _ReviewBookSearchState _state;
  _Controller(this._state);
  String searchKey;

  void onSavedSearchKey(String value) {
    searchKey = value;
  }

  void search() async {
    _state.formKey.currentState.save();

    var results;
    if (searchKey == null || searchKey.trim().isEmpty) {
      results = await FirebaseController.getBKBooks();
    } else {
      results = await FirebaseController.searchBooks(searchKey);
    }

    _state.render(() => _state.bkBooks = results);
  }

  void selectBook(int index) {
    Navigator.pushNamed(_state.context, PostReviewScreen.routeName, arguments: {
      'bkUser': _state.bkUser,
      'bkPosts': _state.bkPosts,
      'homeFeed': _state.homeFeed,
      'bkBook': _state.bkBooks[index],
    });
  }
}
