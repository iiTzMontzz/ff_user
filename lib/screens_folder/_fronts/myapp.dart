import 'package:ff_user/authentication_folder/login.dart';
import 'package:ff_user/screens_folder/_fronts/welcome.dart';
import 'package:ff_user/shared_folder/_constants/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: Welcome(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
      },
    );
  }
}
