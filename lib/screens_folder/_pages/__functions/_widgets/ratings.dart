import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DriverRating extends StatefulWidget {
  final String driverid;
  const DriverRating({this.driverid});
  @override
  _DriverRatingState createState() => _DriverRatingState();
}

class _DriverRatingState extends State<DriverRating> {
  @override
  void initState() {
    super.initState();
    setState(() {
      starCounter = 0.0;
      title = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(22),
            ),
            Text(
              "Rating",
              style: TextStyle(
                  fontSize: getProportionateScreenHeight(20),
                  fontFamily: "Muli",
                  color: Colors.black54),
            ),
            SizedBox(
              height: getProportionateScreenHeight(22),
            ),
            Divider(
              height: getProportionateScreenHeight(2),
              thickness: 2.0,
            ),
            SizedBox(
              height: getProportionateScreenHeight(16),
            ),
            SmoothStarRating(
              rating: starCounter,
              color: Colors.green,
              allowHalfRating: false,
              starCount: 5,
              size: 45,
              onRated: (value) {
                starCounter = value;

                if (starCounter == 1) {
                  setState(() {
                    title = "Very Bad";
                  });
                }
                if (starCounter == 2) {
                  setState(() {
                    title = "Bad";
                  });
                }
                if (starCounter == 3) {
                  setState(() {
                    title = "Good";
                  });
                }
                if (starCounter == 4) {
                  setState(() {
                    title = "Very Good";
                  });
                }
                if (starCounter == 5) {
                  setState(() {
                    title = "Excellent";
                  });
                }
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(14),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(55),
                fontFamily: "Muli",
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(16),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(24.0),
                ),
                onPressed: () async {
                  DatabaseReference driverRatingRef = FirebaseDatabase.instance
                      .reference()
                      .child("drivers/${widget.driverid}/ratings");

                  driverRatingRef.once().then((DataSnapshot snap) {
                    if (snap.value != null) {
                      double oldRatings = double.parse(snap.value.toString());
                      double addRatings = oldRatings + starCounter;
                      double averageRatings = addRatings / 2;
                      driverRatingRef.set(averageRatings.toString());
                    } else {
                      driverRatingRef.set(starCounter.toString());
                    }
                  });

                  Navigator.of(context).pop('closed');
                },
                color: Colors.green[400],
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Muli'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
          ],
        ),
      ),
    );
  }
}
