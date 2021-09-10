import 'dart:async';
import 'package:ff_user/screens_folder/_fronts/_landing/landingPage.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeSplash extends StatelessWidget {
  final bool geostat;
  HomeSplash({this.geostat});
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => (LandingPage(geostat: geostat))));
    });

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: getProportionateScreenHeight(120),
              ),
              Text(
                'Ehatid +',
                style: TextStyle(
                  fontFamily: 'Muli',
                  color: Colors.blueAccent[400],
                  fontSize: getProportionateScreenHeight(30),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Container(
                  height: getProportionateScreenHeight(260),
                  child: Image(image: AssetImage('assets/images/dog.gif'))),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.blue[200],
                  fontSize: getProportionateScreenHeight(22),
                  fontFamily: 'Muli',
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(150),
              ),
              LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                width: 240.0,
                lineHeight: 4.0,
                animation: true,
                percent: 1.0,
                animationDuration: 2250,
                backgroundColor: Colors.blue[100],
                progressColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
