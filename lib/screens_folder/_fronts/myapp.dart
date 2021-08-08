import 'package:ff_user/authentication_folder/login.dart';
import 'package:ff_user/authentication_folder/sign_up.dart';
import 'package:ff_user/models_folder/user.dart';
import 'package:ff_user/screens_folder/_fronts/_landing/landingPage.dart';
import 'package:ff_user/screens_folder/_fronts/get_started.dart';
import 'package:ff_user/screens_folder/_fronts/welcome.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/driver.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/history.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/onReview.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/profile.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/wallet.dart';
import 'package:ff_user/screens_folder/_pages/__functions/pet_reciever.dart';
import 'package:ff_user/screens_folder/_pages/__functions/ride_request.dart';
import 'package:ff_user/services_folder/_database/auth.dart';
import 'package:ff_user/shared_folder/_constants/theme.dart';
import 'package:ff_user/wrapper_folder/user_wrapper.dart';
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
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => Login(),
          '/welcome': (BuildContext context) => Welcome(),
          '/signup': (BuildContext context) => Signup(),
          '/getstarted': (BuildContext context) => GetStarted(),
          '/profile': (BuildContext context) => Profile(),
          '/wallet': (BuildContext context) => Wallet(),
          '/history': (BuildContext context) => History(),
          '/landingpage': (BuildContext context) => LandingPage(),
          '/wrapper': (BuildContext context) => Wrapper(),
          '/driver': (BuildContext context) => Driver(),
          '/onreview': (BuildContext context) => OnReview(),
          '/userwrapper': (BuildContext context) => UserWrapper(),
          '/ridereq': (BuildContext context) => RideRequest(),
          '/petreciever': (BuildContext context) => PetReciever(),
        },
      ),
    );
  }
}
