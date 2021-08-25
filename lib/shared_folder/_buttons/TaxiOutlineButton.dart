import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class TaxiOutlineButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;

  TaxiOutlineButton({this.title, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: color),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25.0),
            ),
            primary: color,
            onSurface: color),
        onPressed: onPressed,
        child: Container(
          height: getProportionateScreenHeight(50),
          child: Center(
            child: Text(title,
                style: TextStyle(
                    fontSize: getProportionateScreenHeight(15),
                    fontFamily: 'Muli',
                    color: Colors.black87)),
          ),
        ));
  }
}
