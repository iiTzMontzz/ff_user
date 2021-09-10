import 'package:ff_user/models_folder/enums.dart';
import 'package:ff_user/screens_folder/_fronts/_landing/coustom_bottom_nav_bar.dart';
import 'package:ff_user/screens_folder/_pages/__bottom_nav_bar/home/home.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  final bool geostat;

  const LandingPage({this.geostat});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Home(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
