import 'package:ff_user/models_folder/user.dart';
import 'package:ff_user/services_folder/_database/auth.dart';
import 'package:ff_user/screens_folder/_fronts/routes.dart';
import 'package:ff_user/shared_folder/_constants/theme.dart';
import 'package:ff_user/wrapper_folder/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: Wrapper(),
        routes: routes,
      ),
    );
  }
}
