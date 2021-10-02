import 'package:ff_user/shared_folder/_buttons/TaxiOutlineButton.dart';
import 'package:ff_user/shared_folder/_buttons/trans_button.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class TripCancelationDialog extends StatelessWidget {
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
                  'Waring Messege',
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
                    'You are about to cancel this Reqeust.\n Are you sure?',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                Container(
                  width: getProportionateScreenWidth(200),
                  child: TaxiOutlineButton(
                    title: 'Proceed',
                    color: Colors.grey[400],
                    onPressed: () {
                      Navigator.of(context).pop('proceed');
                    },
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Container(
                  width: getProportionateScreenWidth(200),
                  child: TransparentButton(
                    text: 'Cancel',
                    press: () {
                      Navigator.of(context).pop();
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
