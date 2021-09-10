import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/_user/userSplash.dart';
import 'package:ff_user/shared_folder/_buttons/trans_button.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:flutter/material.dart';

class CarType extends StatefulWidget {
  final String rideType;

  const CarType({this.rideType});

  @override
  _CarTypeState createState() => _CarTypeState();
}

class _CarTypeState extends State<CarType> {
  bool geoS;
  bool geoM;
  bool geoL;

  @override
  void initState() {
    super.initState();
    if (geoSmall == null) {
      geoS = true;
    } else {
      geoS = false;
    }
    if (geoMedium == null) {
      geoMedium = true;
    } else {
      geoM = false;
    }
    if (geoLarge == null) {
      geoL = true;
    } else {
      geoL = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width / 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Choose Car Type",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: getProportionateScreenHeight(18),
                  ),
                ),
              ),
              cars(() {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserSplash(
                          carType: 'aNormal',
                          rideType: widget.rideType,
                          geostat: geoS,
                        )));
              }, context, 'Fsmall.png'),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              cars(() {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserSplash(
                          carType: 'aDelux',
                          rideType: widget.rideType,
                          geostat: geoM,
                        )));
              }, context, 'Fmedium.png'),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              cars(() {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserSplash(
                          carType: 'aVIP',
                          rideType: widget.rideType,
                          geostat: geoL,
                        )));
              }, context, 'FLarge.png'),
              SizedBox(
                height: getProportionateScreenHeight(45),
              ),
              TransparentButton(
                text: 'Cancel',
                press: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cars(onpress, BuildContext context, String image) {
    return Container(
      width:
          MediaQuery.of(context).size.width / getProportionateScreenWidth(1.5),
      height:
          MediaQuery.of(context).size.height / getProportionateScreenHeight(6),
      child: RaisedButton(
        child: Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: 20,
                  left: 10,
                ),
                child: SizedBox(
                  height: getProportionateScreenHeight(40),
                  width: getProportionateScreenWidth(40),
                  child: Image.asset("assets/images/$image"),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FurS",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: getProportionateScreenHeight(18)),
                  ),
                  Text(
                    "Php 40.00",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(12),
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(5),
                  ),
                  Text(
                    "Small Vehicle Type",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onPressed: onpress,
      ),
    );
  }
}
