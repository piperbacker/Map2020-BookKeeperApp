import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BookKeeperApp());
}

class BookKeeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Text("Hello"),
    );

    /*initialRoute: SignInScreen.routeName, routes: {
      SignInScreen.routeName: (context) => SignInScreen(),
      HomeScreen.routeName: (context) => HomeScreen(),
    });*/
  }
}
