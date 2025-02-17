import 'dart:io';

import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/screen/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class AddBookScreen extends StatefulWidget {
  static const routeName = '/manageStore/AddBookScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddBookState();
  }
}

class _AddBookState extends State<AddBookScreen> {
  var formKey = GlobalKey<FormState>();
  _Controller con;
  List<BKBook> bkBooks;
  User user;

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
    bkBooks ??= args['bkBooks'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
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
                      "Upload Book Cover",
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: con.imageFile == null
                        ? SizedBox(height: 1)
                        : Container(
                            margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                            child: Image.file(con.imageFile, fit: BoxFit.fill)),
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
                      "Upload Book File",
                      style: TextStyle(fontSize: 20.0, color: Colors.cyan[900]),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  con.fileName == null
                      ? SizedBox(height: 1)
                      : Container(
                          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                          child: Text(con.fileName,
                              style: TextStyle(
                                fontSize: 20.0,
                              )),
                        ),
                  //Image.file(con.imageFile, fit: BoxFit.fill)),
                  SizedBox(
                    height: 10.0,
                  ),
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
  _AddBookState _state;
  _Controller(this._state);
  File imageFile;
  File bookFile;
  String fileName;
  String title;
  String author;
  String desc;
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
      var p;
      MyDialog.circularProgressStart(_state.context);
      Map<String, String> photoInfo = await FirebaseController.uploadBookCover(
        image: imageFile,
        uid: _state.user.uid,
        listener: (double progressPercentage) {
          _state.render(() {
            uploadProgressMessage =
                'Uploading: ${progressPercentage.toStringAsFixed(1)} %';
          });
        },
      );

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

      p = BKBook(
        photoPath: photoInfo['path'],
        photoURL: photoInfo['url'],
        filePath: fileInfo['path'],
        fileURL: fileInfo['url'],
        title: title,
        author: author,
        description: desc,
        pubDate: DateTime.now(),
      );

      p.docId = await FirebaseController.addBook(p);
      _state.bkBooks.insert(0, p);

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

  String validatorAuthor(String value) {
    if (value == null || value.length < 2 || !validCharacters.hasMatch(value)) {
      return ('Min 2 chars, can only contain alpahabet symbols and spaces');
    } else {
      return null;
    }
  }

  void onSavedAuthor(String value) {
    author = value;
  }

  String validatorDesc(String value) {
    if (value == null || value.trim().length < 3) {
      return 'min 3 chars';
    } else {
      return null;
    }
  }

  void onSavedDesc(String value) {
    desc = value;
  }
}
