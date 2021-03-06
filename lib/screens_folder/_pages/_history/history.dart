import 'package:ff_user/screens_folder/_fronts/home.dart';
import 'package:ff_user/screens_folder/_pages/_history/history_page.dart';
import 'package:ff_user/shared_folder/_buttons/divider.dart';
import 'package:ff_user/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Home()));
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue[300],
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  FadeAnimation(
                    2.5,
                    Text('Past Trips',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Muli',
                            fontSize: 45,
                            fontWeight: FontWeight.w700)),
                  )
                ],
              ),
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              checkHistory(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  FadeAnimation(
                      1.5,
                      Image.asset(
                        'assets/images/destination.png',
                        width: getProportionateScreenWidth(70),
                      )),
                  SizedBox(
                    width: getProportionateScreenWidth(16),
                  ),
                  FadeAnimation(
                      1.5,
                      Text(
                        'View',
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(20),
                            fontFamily: 'Muli'),
                      )),
                ],
              ),
            ),
          ),
          CustomDivider(),
        ],
      ),
    );
  }

  void checkHistory(context) {
    DatabaseReference historef = FirebaseDatabase.instance
        .reference()
        .child('users/${currentUserinfo.uid}/history');

    historef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HistoryPage()));
      } else {
        Toast.show("No History Yet", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    });
  }
}
