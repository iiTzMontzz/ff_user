import 'package:ff_user/models_folder/user.dart';
import 'package:ff_user/screens_folder/_fronts/get_started.dart';
import 'package:ff_user/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user != null) {
      return Splash(route: '/userwrapper');
    } else {
      return GetStarted();
    }
  }
}
