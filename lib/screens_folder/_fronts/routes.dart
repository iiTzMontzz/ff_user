import 'package:ff_user/authentication_folder/login.dart';
import 'package:ff_user/authentication_folder/sign_up.dart';
import 'package:ff_user/screens_folder/_fronts/_landing/landingPage.dart';
import 'package:ff_user/screens_folder/_fronts/get_started.dart';
import 'package:ff_user/screens_folder/_fronts/welcome.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/history.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/profile.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/wallet.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_widgets/pet_reciever.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/ride_request.dart';
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
  '/landingpage': (BuildContext context) => LandingPage(),
  '/wrapper': (BuildContext context) => Wrapper(),
  '/driver': (BuildContext context) => Driver(),
  '/onreview': (BuildContext context) => OnReview(),
  '/userwrapper': (BuildContext context) => UserWrapper(),
  '/ridereqANormal': (BuildContext context) => RideRequest(
        rideType: 'Normal',
        carType: 'aNormal',
      ),
  '/ridereqADelux': (BuildContext context) => RideRequest(
        rideType: 'Normal',
        carType: 'aDelux',
      ),
  '/ridereqAVip': (BuildContext context) => RideRequest(
        rideType: 'Normal',
        carType: 'aVIP',
      ),
  '/ridereq_pet': (BuildContext context) => RideRequest(rideType: 'Pet Only'),
  '/petreciever': (BuildContext context) => PetReciever(),
};
