import 'package:ff_user/shared_folder/_buttons/default_button.dart';
import 'package:ff_user/shared_folder/_buttons/trans_button.dart';
import 'package:ff_user/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_user/shared_folder/_constants/constants.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Tokoto, Let’s shop!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text":
          "We help people conect with store \naround United State of America",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": "assets/images/splash_3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => Column(
                    children: <Widget>[
                      Spacer(),
                      FadeAnimation(
                          1,
                          Text(
                            "TOKOTO",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(36),
                              color: Colors.blueAccent[400],
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      FadeAnimation(
                          1.2,
                          Text(
                            splashData[index]['text'],
                            textAlign: TextAlign.center,
                          )),
                      Spacer(flex: 2),
                      FadeAnimation(
                          1.4,
                          Image.asset(
                            splashData[index]["image"],
                            height: getProportionateScreenHeight(265),
                            width: getProportionateScreenWidth(235),
                          )),
                    ],
                  ),
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
                          2,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              splashData.length,
                              (index) => buildDot(index: index),
                            ),
                          )),
                      Spacer(flex: 1),
                      FadeAnimation(
                          2.5,
                          DefaultButton(
                            text: "Continue",
                            color: Colors.blue[400],
                            press: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Splash(route: '/login')));
                            },
                          )),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      FadeAnimation(
                          2.5,
                          TransparentButton(
                            text: "Return",
                            press: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/getstarted');
                            },
                          )),
                      SizedBox(height: getProportionateScreenHeight(30)),
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

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.blueAccent : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
