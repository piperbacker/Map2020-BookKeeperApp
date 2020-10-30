import 'package:flutter/material.dart';

class MyDialog {
  static void circularProgressStart(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
  }

  static void circularProgressEnd(BuildContext context) {
    Navigator.pop(context);
  }

  static void info({BuildContext context, String title, String content}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ]);
        });
  }
}
