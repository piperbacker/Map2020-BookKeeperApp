import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BookDetailScreen extends StatefulWidget {
  static const routeName = 'home/bookDetailScreen';

  @override
  State<StatefulWidget> createState() {
    return _BookDetailState();
  }
}

class _BookDetailState extends State<BookDetailScreen> {
  User user;
  BKUser bkUser;
  BKBook bkBook;
  List<BKPost> reviews;
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
    bkBook ??= args['bkBook'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${bkBook.title}'),
      ),
      body: Column(
        children: [
          Container(
            width: 150.0,
            height: 225.0,
            child: MyImageView.network(
                imageURL: bkBook.photoURL, context: context),
          ),
          Text(
            bkBook.title,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
          Text(
            bkBook.author,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.cyan[900],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ButtonTheme(
            height: 40.0,
            child: RaisedButton(
              color: Colors.orangeAccent,
              child: Text(
                'Download',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () => con.download,
            ),
          ),
          Divider(height: 50.0, color: Colors.orangeAccent),
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.orange[50],
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  reviews[index].displayName,
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
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                reviews[index].photoURL == null
                                    ? SizedBox(height: 1)
                                    : Container(
                                        alignment: Alignment.topCenter,
                                        margin: EdgeInsets.fromLTRB(
                                            10.0, 5.0, 10.0, 5.0),
                                        child: MyImageView.network(
                                            imageURL: reviews[index].photoURL,
                                            context: context),
                                      ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                reviews[index].bookTitle == null
                                    ? SizedBox(height: 1)
                                    : Container(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: [
                                            Text(
                                              reviews[index].bookTitle,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            Text(
                                              reviews[index].author,
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
                                    reviews[index].title,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Divider(
                                    height: 30.0, color: Colors.orangeAccent),
                                reviews[index].stars == null
                                    ? SizedBox(
                                        height: 1,
                                      )
                                    : Container(
                                        alignment: Alignment.topCenter,
                                        child: SmoothStarRating(
                                          allowHalfRating: false,
                                          starCount: 5,
                                          rating:
                                              reviews[index].stars.toDouble(),
                                          size: 30.0,
                                          isReadOnly: true,
                                          color: Colors.deepOrange[400],
                                          borderColor: Colors.grey,
                                          spacing: 0.0,
                                        ),
                                      ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  reviews[index].body,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              !reviews[index].likedBy.contains(bkUser.email)
                                  ? IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      onPressed: () => con.like(index),
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.favorite),
                                      color: Colors.pink,
                                      onPressed: () => con.unlike(index),
                                    ),
                              reviews[index].postedBy == bkUser.email
                                  ? SizedBox(
                                      height: 1.0,
                                    )
                                  : Row(
                                      children: <Widget>[
                                        !reviews[index]
                                                .likedBy
                                                .contains(bkUser.email)
                                            ? IconButton(
                                                icon:
                                                    Icon(Icons.favorite_border),
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
                              reviews[index].likedBy.length == 0
                                  ? SizedBox(
                                      height: 1.0,
                                    )
                                  : Flexible(
                                      child: Text(
                                        '${reviews[index].likedBy.length} likes',
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
  _BookDetailState _state;
  _Controller(this._state);

  void download() {}

  void like(int index) async {
    _state.render(() {
      if (!_state.reviews[index].likedBy.contains(_state.bkUser.email)) {
        _state.reviews[index].likedBy.add(_state.bkUser.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.reviews[index]);
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
      if (_state.reviews[index].likedBy.contains(_state.bkUser.email)) {
        _state.reviews[index].likedBy.remove(_state.bkUser.email);
      }
    });

    try {
      await FirebaseController.updateLikedBy(_state.reviews[index]);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Unlike photo memo error in saving',
        content: e.message ?? e.toString(),
      );
    }
  }
}
