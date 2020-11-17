import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PostReviewScreen extends StatefulWidget {
  static const routeName = 'home/postReviewScreen';

  @override
  State<StatefulWidget> createState() {
    return _PostReviewState();
  }
}

class _PostReviewState extends State<PostReviewScreen> {
  BKUser bkUser;
  List<BKPost> bkPosts;
  List<BKPost> homeFeed;
  BKBook bkBook;
  var formKey = GlobalKey<FormState>();
  var rating = 0.0;

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
    bkPosts ??= args['bkPosts'];
    homeFeed ??= args['homeFeed'];
    bkBook ??= args['bkBook'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Review'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                color: Colors.orange[50],
                height: 1000,
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    height: 300.0,
                    child: MyImageView.network(
                        imageURL: bkBook.photoURL, context: context),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    bkBook.title,
                    style: TextStyle(
                      fontSize: 20.0,
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
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                      style: TextStyle(fontSize: 25.0, color: Colors.cyan[900]),
                      autocorrect: true,
                      validator: con.validatorTitle,
                      onSaved: con.onSavedTitle,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Rating',
                      style: TextStyle(
                        fontSize: 20.0,
                        //color: Colors.deepOrange[400],
                      ),
                    ),
                  ),
                  SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (value) {
                      render(() {
                        rating = value;
                      });
                    },
                    starCount: 5,
                    rating: rating,
                    size: 40.0,
                    isReadOnly: false,
                    //fullRatedIconData: Icons.blur_off,
                    //halfRatedIconData: Icons.blur_on,
                    color: Colors.deepOrange[400],
                    borderColor: Colors.grey,
                    spacing: 0.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Write your book review here...',
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      autocorrect: true,
                      validator: con.validatorBody,
                      onSaved: con.onSavedBody,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _PostReviewState _state;
  _Controller(this._state);
  String title;
  String body;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      var p;
      MyDialog.circularProgressStart(_state.context);

      p = BKPost(
        author: _state.bkBook.author,
        bookTitle: _state.bkBook.title,
        stars: _state.rating.toInt(),
        photoPath: _state.bkBook.photoPath,
        photoURL: _state.bkBook.photoURL,
        title: title,
        body: body,
        postedBy: _state.bkUser.email,
        displayName: _state.bkUser.displayName,
        updatedAt: DateTime.now(),
      );

      p.docId = await FirebaseController.addPost(p);
      _state.bkPosts.insert(0, p);
      _state.homeFeed.insert(0, p);

      MyDialog.circularProgressEnd(_state.context);

      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);

      MyDialog.info(
        context: _state.context,
        title: 'Firebase Error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorTitle(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedTitle(String value) {
    title = value;
  }

  String validatorBody(String value) {
    if (value == null || value.trim().length < 3) {
      return 'min 3 chars';
    } else {
      return null;
    }
  }

  void onSavedBody(String value) {
    body = value;
  }
}
