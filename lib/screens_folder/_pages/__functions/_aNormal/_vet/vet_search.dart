import 'package:ff_user/models_folder/veterinary.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/_vet/vet_tile.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/helper_method.dart';
import 'package:ff_user/services_folder/_helper/request_helper.dart';
import 'package:ff_user/shared_folder/_buttons/divider.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/key.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class VetSearch extends StatefulWidget {
  @override
  _VetSearchState createState() => _VetSearchState();
}

class _VetSearchState extends State<VetSearch> {
  var geolocator = Geolocator();
  List<Veterinaries> listVets = [];
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nearestVet();
  }

  @override
  Widget build(BuildContext context) {
    String address = (Provider.of<AppData>(context).pickupAddress != null)
        ? Provider.of<AppData>(context).pickupAddress.placename
        : 'Getting Current Location....';
    pickupController.text = address;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: getProportionateScreenHeight(200),
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
                          'Nearest Veterinary',
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
                      SizedBox(width: 18),
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
                ],
              ),
            ),
          ),
          (listVets.length > 0)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: listVets.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        CustomDivider(),
                    itemBuilder: (context, index) {
                      return VetTile(vet: listVets[index]);
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  void nearestVet() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    String address =
        await HelperMethod.findCoordinateAddress(position, context);
    print('VETERENIARYY _+___>>>>>>>>>>>>>>>' + address);
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=2000&type=veterinary_care&key=$androidID';

    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      var jsonVetList = response['results'];
      var thisList =
          (jsonVetList as List).map((e) => Veterinaries.fromJson(e)).toList();
      print(response);
      setState(() {
        listVets = thisList;
      });
    }
  }
}
