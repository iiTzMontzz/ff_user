import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String status;
  ProgressDialog({this.status});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: Colors.transparent,
      child: Expanded(
        child: Container(
          margin: EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(width: getProportionateScreenWidth(5)),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]),
                ),
                SizedBox(width: getProportionateScreenWidth(25)),
                Text(
                  status,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'Muli',
                      fontSize: getProportionateScreenHeight(18)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
