import 'package:ff_user/screens_folder/_pages/_history/history.dart';
import 'package:ff_user/services_folder/_helper/helper_method.dart';
import 'package:ff_user/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    HelperMethod.getcurrentUserInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenWidth(20)),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: FadeAnimation(
                      2.5,
                      Text(
                        "Ehatid +",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          fontFamily: 'Muli',
                        ),
                      )),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                FadeAnimation(
                    2,
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: FadeAnimation(
                          1,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Category",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Icon(
                                Icons.more_horiz,
                                color: Colors.grey[800],
                              ),
                            ],
                          )),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      FadeAnimation(
                        1.1,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildPetCategory(
                              category: 'Set Trip',
                              color: Colors.white,
                              image: 'assets/images/new_trip.png',
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Splash(route: '/ridereq')));
                              },
                            ),
                            buildPetCategory(
                              category: 'Profile',
                              color: Colors.white,
                              image: 'assets/images/user.png',
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Splash(route: '/reciever')));
                              },
                            ),
                          ],
                        ),
                      ),
                      FadeAnimation(
                        1.3,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildPetCategory(
                                category: 'Wallet',
                                color: Colors.white,
                                image: 'assets/images/wallet.png',
                                onTap: () {}),
                            buildPetCategory(
                              category: 'History',
                              color: Colors.white,
                              image: 'assets/images/history.png',
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => History()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FadeAnimation(
                  2,
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Options",
                          style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: getProportionateScreenHeight(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.grey[800],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      FadeAnimation(
                        1.4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildPetCategory(
                                category: 'Support',
                                color: Colors.white,
                                image: 'assets/images/wallet.png',
                                onTap: () {}),
                            buildPetCategory(
                              category: 'Log out',
                              color: Colors.white,
                              image: 'assets/images/history.png',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPetCategory({String category, String image, Color color, onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: getProportionateScreenHeight(80),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[200],
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: getProportionateScreenHeight(56),
                width: getProportionateScreenWidth(56),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.5),
                ),
                child: Center(
                  child: SizedBox(
                    height: getProportionateScreenHeight(30),
                    width: getProportionateScreenWidth(30),
                    child: Image.asset(
                      image,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        category,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Muli',
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
