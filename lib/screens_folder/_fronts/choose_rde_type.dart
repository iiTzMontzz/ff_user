import 'package:ff_user/shared_folder/_buttons/TaxiOutlineButton.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';

class ChooseRideType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  'Ride Type',
                  style: TextStyle(
                      fontSize: getProportionateScreenHeight(22),
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                Container(
                  width: getProportionateScreenWidth(200),
                  child: TaxiOutlineButton(
                    title: 'Normal',
                    color: Colors.grey[700],
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Splash(route: '/ridereq')));
                    },
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                Container(
                  width: getProportionateScreenWidth(200),
                  child: TaxiOutlineButton(
                    title: 'Pet Only',
                    color: Colors.grey[700],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
