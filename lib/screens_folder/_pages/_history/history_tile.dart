import 'package:ff_user/models_folder/history.dart';
import 'package:ff_user/services_folder/_helper/helper_method.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final History history;
  HistoryTile({this.history});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            'Trip ID: ${history.key}',
                            style: TextStyle(
                                fontFamily: 'Muli',
                                fontWeight: FontWeight.w600,
                                fontSize: getProportionateScreenHeight(16),
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(5),
                      ),
                      Container(
                        child: Text(
                          'Php ${history.fares}',
                          style: TextStyle(
                              fontFamily: 'Muli',
                              fontWeight: FontWeight.w600,
                              fontSize: getProportionateScreenHeight(16),
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                Container(
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/rec.png',
                        height: getProportionateScreenHeight(16),
                        width: getProportionateScreenWidth(16),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(18),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            history.pickup,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(16),
                              color: Colors.black,
                              fontFamily: 'Muli',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(8),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/pin.png',
                      height: getProportionateScreenHeight(16),
                      width: getProportionateScreenWidth(16),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(18),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          history.destination,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(16),
                            color: Colors.black,
                            fontFamily: 'Muli',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          HelperMethod.formatMyDate(history.createdAt),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Muli',
                              fontSize: getProportionateScreenHeight(14),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(24),
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: () {},
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Image.asset(
                            'assets/images/messenger.png',
                            width: getProportionateScreenWidth(22),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
