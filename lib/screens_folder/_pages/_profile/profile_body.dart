import 'package:ff_user/shared_folder/_constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileBody extends StatelessWidget {
  final Function press;
  final String icon;
  final String text;
  final bool editable;

  const ProfileBody({this.press, this.icon, this.text, this.editable});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: editable == true
            ? TextButton(
                style: TextButton.styleFrom(
                  primary: kPrimaryColor,
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: press,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      icon,
                      color: kPrimaryColor,
                      width: 22,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      text,
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 14,
                          color: Colors.black54),
                    )),
                    Icon(Icons.edit),
                  ],
                ),
              )
            : TextButton(
                style: TextButton.styleFrom(
                  primary: kPrimaryColor,
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    SvgPicture.asset(
                      icon,
                      color: kPrimaryColor,
                      width: 22,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      text,
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 14,
                          color: Colors.black54),
                    )),
                  ],
                ),
              ));
  }
}
