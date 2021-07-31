import 'package:ff_user/shared_folder/_buttons/default_button.dart';
import 'package:ff_user/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: getProportionateScreenHeight(50)),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Fur Fetch +",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(36),
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(height: getProportionateScreenHeight(60)),
                    FadeAnimation(
                        1.4,
                        Image.asset(
                          "assets/images/pet.gif",
                          height: getProportionateScreenHeight(265),
                          width: getProportionateScreenWidth(235),
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      FadeAnimation(
                          2.5,
                          DefaultButton(
                            text: "Get Started",
                            color: Colors.blue[300],
                            press: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/welcome');
                            },
                          )),
                      SizedBox(height: getProportionateScreenHeight(50)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
