import 'package:bookkeeperapp/screen/changepassword_screen.dart';
import 'package:bookkeeperapp/screen/editprofile_screen.dart';
import 'package:bookkeeperapp/screen/home_screen.dart';
import 'package:bookkeeperapp/screen/library_screen.dart';
import 'package:bookkeeperapp/screen/settings_screen.dart';
import 'package:bookkeeperapp/screen/shop_screen.dart';
import 'package:bookkeeperapp/screen/signin_screen.dart';
import 'package:bookkeeperapp/screen/signup_screen.dart';
import 'package:bookkeeperapp/screen/views/profile_screen.dart';
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.amber[300],
          accentColor: Colors.orangeAccent,
          //fontFamily: 'Arimo',
        ),
        initialRoute: SignInScreen.routeName,
        routes: {
          SignInScreen.routeName: (context) => SignInScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          LibraryScreen.routeName: (context) => LibraryScreen(),
          ShopScreen.routeName: (context) => ShopScreen(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          EditProfileScreen.routeName: (context) => EditProfileScreen(),
          ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
        });
  }
}
