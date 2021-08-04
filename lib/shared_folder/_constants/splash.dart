import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Splash extends StatelessWidget {
  final String route;
  Splash({this.route});
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacementNamed(route);
    });

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 120,
              ),
              Text(
                'Fur Fetch +',
                style: TextStyle(
                  fontFamily: 'Muli',
                  color: Colors.blueAccent[400],
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 260,
                  child: Image(image: AssetImage('assets/images/dog.gif'))),
              SizedBox(
                height: 15,
              ),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.blue[200],
                  fontSize: 22,
                  fontFamily: 'Muli',
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(
                height: 150,
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
