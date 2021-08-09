import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onpress;

  const MainButton({Key key, this.color, this.title, this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onpress,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(25),
      ),
      color: color,
      textColor: Colors.white,
      child: Container(
        height: getProportionateScreenHeight(50),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 20, fontFamily: 'Muli', fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
