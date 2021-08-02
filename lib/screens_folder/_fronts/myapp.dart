import 'package:ff_user/authentication_folder/login.dart';
import 'package:ff_user/authentication_folder/sign_up.dart';
import 'package:ff_user/screens_folder/_fronts/_landing/landingPage.dart';
import 'package:ff_user/screens_folder/_fronts/get_started.dart';
import 'package:ff_user/screens_folder/_fronts/welcome.dart';
import 'package:ff_user/screens_folder/_pages/profile.dart';
import 'package:ff_user/shared_folder/_constants/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: GetStarted(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        '/welcome': (BuildContext context) => Welcome(),
        '/signup': (BuildContext context) => Signup(),
        '/getstarted': (BuildContext context) => GetStarted(),
        '/profile': (BuildContext context) => Profile(),
        '/landingpage': (BuildContext context) => LandingPage(),
      },
    );
  }
}
