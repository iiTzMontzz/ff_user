import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(115),
      width: getProportionateScreenWidth(115),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Text(
            'Profile',
            style: TextStyle(
                fontSize: getProportionateScreenHeight(40),
                fontWeight: FontWeight.w700,
                fontFamily: 'Muli'),
          )
        ],
      ),
    );
  }
}
