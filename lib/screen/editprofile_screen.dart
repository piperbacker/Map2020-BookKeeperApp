import 'dart:io';

import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/settings_screen.dart';
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
  BKUser bkUser;
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
    bkUser ??= arg['bkUser'];

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
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.cyan[900],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Stack(
                children: <Widget>[
                  con.imageFile == null
                      ? Container(
                          height: 150,
                          width: 150,
                          child: ClipOval(
                            child: MyImageView.network(
                                imageURL: user.photoURL, context: context),
                          ),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          child: ClipOval(
                            child: Image.file(con.imageFile),
                          ),
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
                  color: Colors.cyan[900],
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
              SizedBox(
                height: 40.0,
              ),
              Text(
                'Edit Bio',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.cyan[900],
                ),
              ),
              TextFormField(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  hintText: 'A short description...',
                ),
                initialValue: bkUser.userBio,
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: con.validatorBio,
                onSaved: con.onSavedBio,
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
  //String bio;
  String progressMessage;
  static final validCharacters = RegExp(r'^[a-zA-Z ]+$');

  void save() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      await FirebaseController.updateProfile(
          image: imageFile,
          displayName: displayName,
          user: _state.user,
          bkUser: _state.bkUser,
          progressListener: (double percentage) {
            _state.render(() {
              progressMessage = 'Uploading ${percentage.toStringAsFixed(1)} %';
            });
          });
      _state.render(() {
        //_state.user.reload();
        //_state.user = FirebaseAuth.instance.currentUser;
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
    if (value == null || value.length < 2 || !validCharacters.hasMatch(value)) {
      return ('Min 2 chars, can only contain alpahabet symbols and spaces');
    } else {
      return null;
    }
  }

  void onSavedDisplayName(String value) {
    this.displayName = value;
  }

  String validatorBio(String value) {
    if (value == null || value.trim().length < 3) {
      return 'min 3 chars';
    } else {
      return null;
    }
  }

  void onSavedBio(String value) {
    print(_state.bkUser);
    _state.bkUser.userBio = value;
    print("=========" + _state.bkUser.userBio);
  }
}
