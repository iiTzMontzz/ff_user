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
                SizedBox(width: 5.0),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]),
                ),
                SizedBox(width: 25.0),
                Text(
                  status,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontFamily: 'Muli', fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
