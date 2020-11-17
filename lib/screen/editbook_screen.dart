import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:bookkeeperapp/screen/views/myimageview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class EditBookScreen extends StatefulWidget {
  static const routeName = '/manageShop/editBookScreen';

  @override
  State<StatefulWidget> createState() {
    return _EditBookState();
  }
}

class _EditBookState extends State<EditBookScreen> {
  User user;
  BKUser bkUser;
  BKBook bkBook;
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
    user ??= args['user'];
    bkUser ??= args['bkUser'];
    bkBook ??= args['bkBook'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book'),
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
                  height: 1300),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 15.0, 5.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Update Book Cover",
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 300.0,
                    child: con.imageFile == null
                        ? MyImageView.network(
                            imageURL: bkBook.photoURL, context: context)
                        : Image.file(con.imageFile, fit: BoxFit.fill),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        onPressed: con.getPicture,
                        child: Container(
                          width: 150.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.photo_camera),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("Upload Photo",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                            ],
                          ),
                        ),
                        color: Colors.teal[400],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 15.0, 5.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Update Book File",
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  /*con.fileName == null
                      ? con.fileName = bkBook.bookFile.path.split('/').last;
                      : Container(
                          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                          child: Text(con.fileName,
                              style: TextStyle(
                                fontSize: 20.0,
                              )),
                        ),
                  SizedBox(
                    height: 10.0,
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        onPressed: con.getBookFile,
                        child: Container(
                          width: 150.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.attach_file),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("Upload File",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                            ],
                          ),
                        ),
                        color: Colors.teal[400],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Book Title',
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                      autocorrect: true,
                      initialValue: bkBook.title,
                      validator: con.validatorTitle,
                      onSaved: con.onSavedTitle,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Book Author',
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                      autocorrect: true,
                      initialValue: bkBook.author,
                      validator: con.validatorAuthor,
                      onSaved: con.onSavedAuthor,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Book Description',
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                      keyboardType: TextInputType.multiline,
                      initialValue: bkBook.description,
                      maxLines: 6,
                      autocorrect: true,
                      validator: con.validatorDesc,
                      onSaved: con.onSavedDesc,
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
  _EditBookState _state;
  _Controller(this._state);
  File imageFile;
  File bookFile;
  String fileName;
  String uploadProgressMessage;
  static final validCharacters = RegExp(r'^[a-zA-Z ]+$');

  void getPicture() async {
    try {
      PickedFile _imageFile;
      _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);

      _state.render(() {
        imageFile = File(_imageFile.path);
      });
    } catch (e) {}
  }

  void getBookFile() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      File _file = File(result.files.single.path);
      _state.render(() {
        bookFile = File(_file.path);
        fileName = bookFile.path.split('/').last;
      });
    } catch (e) {}
  }

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);
      if (imageFile != null) {
        Map<String, String> photoInfo =
            await FirebaseController.uploadBookCover(
          image: imageFile,
          uid: _state.user.uid,
          listener: (double progressPercentage) {
            _state.render(() {
              uploadProgressMessage =
                  'Uploading: ${progressPercentage.toStringAsFixed(1)} %';
            });
          },
        );
        _state.bkBook.photoPath = photoInfo['path'];
        _state.bkBook.photoURL = photoInfo['url'];
      }

      if (bookFile != null) {
        Map<String, String> fileInfo = await FirebaseController.uploadBookFile(
          bookFile: bookFile,
          uid: _state.user.uid,
          listener: (double progressPercentage) {
            _state.render(() {
              uploadProgressMessage =
                  'Uploading: ${progressPercentage.toStringAsFixed(1)} %';
            });
          },
        );
        _state.bkBook.filePath = fileInfo['path'];
        _state.bkBook.fileURL = fileInfo['url'];
      }

      _state.render(() => uploadProgressMessage = 'Firestore doc updating ...');
      await FirebaseController.updateBKBook(_state.bkBook);

      MyDialog.circularProgressEnd(_state.context);

      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);

      MyDialog.info(
        context: _state.context,
        title: 'Edit Book error in saving',
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
    _state.bkBook.title = value;
  }

  String validatorAuthor(String value) {
    if (value == null || value.length < 2 || !validCharacters.hasMatch(value)) {
      return ('Min 2 chars, can only contain alpahabet symbols and spaces');
    } else {
      return null;
    }
  }

  void onSavedAuthor(String value) {
    _state.bkBook.author = value;
  }

  String validatorDesc(String value) {
    if (value == null || value.trim().length < 3) {
      return 'min 3 chars';
    } else {
      return null;
    }
  }

  void onSavedDesc(String value) {
    _state.bkBook.description = value;
  }
}
