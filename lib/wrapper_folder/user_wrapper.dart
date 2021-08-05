import 'package:ff_user/authentication_folder/sign_up.dart';
import 'package:ff_user/models_folder/person.dart';
import 'package:ff_user/models_folder/user.dart';
import 'package:ff_user/screens_folder/_fronts/_landing/landingPage.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/driver.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/onReview.dart';
import 'package:ff_user/services_folder/_database/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserWrapper extends StatefulWidget {
  @override
  _UserWrapperState createState() => _UserWrapperState();
}

class _UserWrapperState extends State<UserWrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return StreamBuilder<Person>(
      stream: Data(uid: user.uid).persons,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.type == 'Passenger') {
            if (snapshot.data.availability == 'Enabled') {
              return LandingPage();
            } else {
              return OnReview();
            }
          } else {
            return Driver();
          }
        } else {
          return Signup();
        }
      },
    );
  }
}
