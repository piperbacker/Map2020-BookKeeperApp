import 'dart:io';

import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkpost.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostUpdateScreen extends StatefulWidget {
  static const routeName = 'home/postUpdateScreen';

  @override
  State<StatefulWidget> createState() {
    return _PostUpdateState();
  }
}

class _PostUpdateState extends State<PostUpdateScreen> {
  User user;
  BKUser bkUser;
  List<BKPost> bkPosts;
  var formKey = GlobalKey<FormState>();
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
    bkPosts ??= args['bkPosts'];

    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
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
                height: 600,
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                      style: TextStyle(fontSize: 30.0, color: Colors.cyan[900]),
                      autocorrect: true,
                      validator: con.validatorTitle,
                      onSaved: con.onSavedTitle,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Write your update here...',
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      autocorrect: true,
                      validator: con.validatorMemo,
                      onSaved: con.onSavedMemo,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Add Photo",
                    style: TextStyle(fontSize: 24.0, color: Colors.cyan[900]),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        onPressed: () => con.getPicture('Camera'),
                        child: Container(
                          width: 130.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.photo_camera),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("Camera",
                                  style: TextStyle(
                                    fontSize: 22.0,
                                  )),
                            ],
                          ),
                        ),
                        color: Colors.teal[400],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        onPressed: () => con.getPicture('Gallery'),
                        child: Container(
                          width: 130.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.photo_album),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("Gallery",
                                  style: TextStyle(
                                    fontSize: 22.0,
                                  )),
                            ],
                          ),
                        ),
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: con.imageFile == null
                        ? SizedBox(height: 1)
                        : Container(
                            margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                            child: Image.file(con.imageFile, fit: BoxFit.fill)),
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
  _PostUpdateState _state;
  _Controller(this._state);
  File imageFile;
  String title;
  String body;
  String uploadProgressMessage;

  void getPicture(String src) async {
    try {
      PickedFile _imageFile;
      if (src == 'Camera') {
        _imageFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
      }

      _state.render(() {
        imageFile = File(_imageFile.path);
      });
    } catch (e) {}
  }

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      var p;
      MyDialog.circularProgressStart(_state.context);

      if (imageFile != null) {
        // if there is an image attached in update

        Map<String, String> photoInfo = await FirebaseController.uploadStorage(
          image: imageFile,
          uid: _state.user.uid,
          listener: (double progressPercentage) {
            _state.render(() {
              uploadProgressMessage =
                  'Uploading: ${progressPercentage.toStringAsFixed(1)} %';
            });
          },
        );

        p = BKPost(
          photoPath: photoInfo['path'],
          photoURL: photoInfo['url'],
          title: title,
          body: body,
          postedBy: _state.bkUser.email,
          displayName: _state.bkUser.displayName,
          updatedAt: DateTime.now(),
        );
      } else {
        // if there is no image attached in update
        p = BKPost(
          title: title,
          body: body,
          postedBy: _state.bkUser.email,
          displayName: _state.bkUser.displayName,
          updatedAt: DateTime.now(),
        );
      }

      p.docId = await FirebaseController.addPost(p);
      _state.bkPosts.insert(0, p);

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

  String validatorMemo(String value) {
    if (value == null || value.trim().length < 3) {
      return 'min 3 chars';
    } else {
      return null;
    }
  }

  void onSavedMemo(String value) {
    body = value;
  }
}
