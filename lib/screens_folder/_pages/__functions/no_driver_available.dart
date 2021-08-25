import 'package:ff_user/shared_folder/_buttons/TaxiOutlineButton.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class NoDriverAvailable extends StatelessWidget {
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
                  'No Drivers Available',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(22),
                    fontFamily: 'Muli',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'No available driver close by, try again shortly',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                Container(
                  width: getProportionateScreenWidth(200),
                  child: TaxiOutlineButton(
                    title: 'Close',
                    color: Colors.grey[400],
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/wrapper');
                    },
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
