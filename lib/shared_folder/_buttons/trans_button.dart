import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String text;
  final Function press;
  const TransparentButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.transparent,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.blue,
            fontFamily: 'Muli',
          ),
        ),
      ),
    );
  }
}
