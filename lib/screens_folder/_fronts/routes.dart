import 'package:ff_user/authentication_folder/login.dart';
import 'package:ff_user/authentication_folder/sign_up.dart';
import 'package:ff_user/screens_folder/_fronts/get_started.dart';
import 'package:ff_user/screens_folder/_fronts/home.dart';
import 'package:ff_user/screens_folder/_fronts/welcome.dart';
import 'package:ff_user/screens_folder/_pages/_history/history.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_widgets/profile.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_widgets/wallet.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_widgets/pet_reciever.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/ride_request.dart';
import 'package:ff_user/screens_folder/_pages/_profile/profile.dart';
import 'package:ff_user/wrapper_folder/driver.dart';
import 'package:ff_user/wrapper_folder/onReview.dart';
import 'package:ff_user/wrapper_folder/user_wrapper.dart';
import 'package:ff_user/wrapper_folder/wrapper.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/login': (BuildContext context) => Login(),
  '/welcome': (BuildContext context) => Welcome(),
  '/signup': (BuildContext context) => Signup(),
  '/getstarted': (BuildContext context) => GetStarted(),
  '/profile': (BuildContext context) => Profile(),
  '/wallet': (BuildContext context) => Wallet(),
  '/history': (BuildContext context) => History(),
  '/wrapper': (BuildContext context) => Wrapper(),
  '/driver': (BuildContext context) => Driver(),
  '/onreview': (BuildContext context) => OnReview(),
  '/userwrapper': (BuildContext context) => UserWrapper(),
  '/ridereq': (BuildContext context) => RideRequest(rideType: 'Normal'),
  '/ridereq_pet': (BuildContext context) => RideRequest(rideType: 'Pet Only'),
  '/petreciever': (BuildContext context) => PetReciever(),
  '/home': (BuildContext context) => Home(),
  '/myprofile': (BuildContext context) => MyProfile(),
};
