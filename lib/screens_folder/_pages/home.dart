import 'package:ff_user/services_folder/_database/auth.dart';
import 'package:ff_user/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: TextButton(
            child: Text("Home"),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Splash(route: '/wrapper')));
            },
          ),
        ),
      ),
    );
  }
}
