import 'package:ff_user/services_folder/_database/auth.dart';
import 'package:ff_user/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: SafeArea(
          child: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Splash(route: '/wrapper')));
            },
            child: Text(
              "Log out",
              style: TextStyle(fontFamily: 'Muli'),
            ),
          ),
        ),
      )),
    );
  }
}
