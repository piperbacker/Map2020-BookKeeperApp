import 'package:bookkeeperapp/screen/addbook_screen.dart';
import 'package:bookkeeperapp/screen/adminhome_screen.dart';
import 'package:bookkeeperapp/screen/changepassword_screen.dart';
import 'package:bookkeeperapp/screen/createnewaccount_screen.dart';
import 'package:bookkeeperapp/screen/editbook_screen.dart';
import 'package:bookkeeperapp/screen/editprofile_screen.dart';
import 'package:bookkeeperapp/screen/librar_screen.dart';
import 'package:bookkeeperapp/screen/managestore_screen.dart';
import 'package:bookkeeperapp/screen/myfollowers_screen.dart';
import 'package:bookkeeperapp/screen/myfollowing_screen.dart';
import 'package:bookkeeperapp/screen/home_screen.dart';
import 'package:bookkeeperapp/screen/postreview_screen.dart';
import 'package:bookkeeperapp/screen/postupdate_screen.dart';
import 'package:bookkeeperapp/screen/settings_screen.dart';
import 'package:bookkeeperapp/screen/shop_screen.dart';
import 'package:bookkeeperapp/screen/signin_screen.dart';
import 'package:bookkeeperapp/screen/signup_screen.dart';
import 'package:bookkeeperapp/screen/userfollowers_screen.dart';
import 'package:bookkeeperapp/screen/userfollowing_screen.dart';
import 'package:bookkeeperapp/screen/userprofile_screen.dart';
import 'package:bookkeeperapp/screen/usersearch_screen.dart';
import 'package:bookkeeperapp/screen/myprofile_screen.dart';
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
          MyProfileScreen.routeName: (context) => MyProfileScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          EditProfileScreen.routeName: (context) => EditProfileScreen(),
          ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
          PostUpdateScreen.routeName: (context) => PostUpdateScreen(),
          PostReviewScreen.routeName: (context) => PostReviewScreen(),
          UserSearchScreen.routeName: (context) => UserSearchScreen(),
          UserProfileScreen.routeName: (context) => UserProfileScreen(),
          MyFollowingScreen.routeName: (context) => MyFollowingScreen(),
          MyFollowersScreen.routeName: (context) => MyFollowersScreen(),
          UserFollowingScreen.routeName: (context) => UserFollowingScreen(),
          UserFollowersScreen.routeName: (context) => UserFollowersScreen(),
          AdminHomeScreen.routeName: (context) => AdminHomeScreen(),
          ManageStoreScreen.routeName: (context) => ManageStoreScreen(),
          AddBookScreen.routeName: (context) => AddBookScreen(),
          EditBookScreen.routeName: (context) => EditBookScreen(),
          CreateNewAccountScreen.routeName: (context) =>
              CreateNewAccountScreen(),
        });
  }
}
