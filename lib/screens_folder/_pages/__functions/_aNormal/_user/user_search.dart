import 'package:ff_user/models_folder/predictions.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/_user/user_tile.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/request_helper.dart';
import 'package:ff_user/shared_folder/_buttons/divider.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  var focusDestination = FocusNode();
  List<Predictions> destinationList = [];
  bool focus = false;
  @override
  Widget build(BuildContext context) {
    setFocus();
    String address = (Provider.of<AppData>(context).pickupAddress != null)
        ? Provider.of<AppData>(context).pickupAddress.placename
        : 'Getting Current Location....';
    pickupController.text = address;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: getProportionateScreenHeight(300),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(5)),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Center(
                        child: Text(
                          'Set Trip',
                          style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: getProportionateScreenHeight(22),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/rec.png',
                        height: getProportionateScreenHeight(16),
                        width: getProportionateScreenWidth(16),
                      ),
                      SizedBox(width: getProportionateScreenWidth(18)),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              controller: pickupController,
                              decoration: InputDecoration(
                                enabled: false,
                                hintText: 'Pick up',
                                fillColor: Colors.grey[50],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Muli',
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/pin.png',
                        height: getProportionateScreenHeight(16),
                        width: getProportionateScreenWidth(16),
                      ),
                      SizedBox(width: getProportionateScreenWidth(18)),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (value) {
                                searchPlace(value);
                              },
                              controller: destinationController,
                              focusNode: focusDestination,
                              decoration: InputDecoration(
                                hintText: 'Destination',
                                fillColor: Colors.grey[50],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  bottom: 15,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Muli',
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (destinationList.length > 0)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0),
                    itemCount: destinationList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        CustomDivider(),
                    itemBuilder: (context, index) {
                      return UserTile(predictions: destinationList[index]);
                    },
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void setFocus() {
    if (!focus) {
      FocusScope.of(context).requestFocus(focusDestination);
      focus = true;
    }
  }

  void searchPlace(String placeName) async {
    var uuid = Uuid();

    if (placeName.length > 1) {
      String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&location=7.1907,125.4553&radius=49436.8284&key=$androidID&sessiontoken=${uuid.v4()}&components=country:ph&regions=postal_code:8000';
      var response = await RequestHelper.getRequest(url);
      if (response == 'failed') {
        return;
      }
      if (response['status'] == 'OK') {
        var jsonpredictions = response['predictions'];
        var thisList = (jsonpredictions as List)
            .map((e) => Predictions.fromJson(e))
            .toList();
        print(response);
        setState(() {
          destinationList = thisList;
        });
      }
    }
  }
}
