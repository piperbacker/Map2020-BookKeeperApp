import 'dart:io';

import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/settingsScreen/editProfileScreen';

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfileScreen> {
  User user;
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
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
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
          child: Column(
            children: <Widget>[
              Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Stack(
                children: <Widget>[
                  con.imageFile == null
                      ? CircleAvatar(
                          child: MyImageView.network(
                              imageURL: user.photoURL, context: context),
                          radius: 60.0,
                        )
                      : CircleAvatar(
                          child: Image.file(con.imageFile),
                          radius: 60.0,
                        ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      child: PopupMenuButton<String>(
                        onSelected: con.getPicture,
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            value: 'Camera',
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.camera),
                                Text('camera')
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Gallery',
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.photo_album),
                                Text('gallery')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              con.progressMessage == null
                  ? SizedBox(height: 1.0)
                  : Text(
                      con.progressMessage,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                'Change Display Name',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              TextFormField(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Display Name',
                ),
                autocorrect: false,
                initialValue: user.displayName ?? 'N/A',
                validator: con.validatorDisplayName,
                onSaved: con.onSavedDisplayName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _EditProfileState _state;
  _Controller(this._state);
  File imageFile;
  String displayName;
  String progressMessage;

  void save() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      await FirebaseController.updateProfile(
          image: imageFile,
          displayName: displayName,
          user: _state.user,
          progressListener: (double percentage) {
            _state.render(() {
              progressMessage = 'Uploading ${percentage.toStringAsFixed(1)} %';
            });
          });
      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Profile update error',
        content: e.message ?? e.toString(),
      );
    }
  }

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
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Image capture error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorDisplayName(String value) {
    if (value.length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedDisplayName(String value) {
    this.displayName = value;
  }
}
