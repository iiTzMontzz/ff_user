import 'package:ff_user/shared_folder/_buttons/divider.dart';
import 'package:ff_user/shared_folder/_buttons/main_button.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class PaymentsDialog extends StatelessWidget {
  final int fare;

  const PaymentsDialog({this.fare});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Text('Total Payment'),
            SizedBox(height: getProportionateScreenHeight(20)),
            CustomDivider(),
            SizedBox(height: getProportionateScreenHeight(30)),
            Text(
              'Php $fare',
              style: TextStyle(
                fontFamily: 'Muli',
                fontSize: getProportionateScreenHeight(50),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Total Fare',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Container(
              width: getProportionateScreenWidth(230),
              child: MainButton(
                title: 'Pay',
                color: Colors.greenAccent[400],
                onpress: () async {
                  Navigator.of(context).pop('close');
                },
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
          ],
        ),
      ),
    );
  }
}
