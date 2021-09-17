import 'package:ff_user/models_folder/veterinary.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/_vet/vet_tile.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/helper_method.dart';
import 'package:ff_user/services_folder/_helper/request_helper.dart';
import 'package:ff_user/shared_folder/_buttons/divider.dart';
import 'package:ff_user/shared_folder/_global/key.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Searchvet extends StatefulWidget {
  @override
  _SearchvetState createState() => _SearchvetState();
}

class _SearchvetState extends State<Searchvet> {
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Nearest Veterinary",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [boxShadow()],
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 25),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
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
          ),
          vetDisplay(context),
        ],
      ),
    );
  }

  Widget vetDisplay(context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.4,
        child: Stack(
          children: <Widget>[
            (listVets.length > 0)
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listVets.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          CustomDivider(),
                      itemBuilder: (context, index) {
                        return VetTile(vet: listVets[index]);
                      },
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }

  boxShadow() {
    return BoxShadow(
      color: Colors.black45,
      blurRadius: 3.0,
      spreadRadius: 0.5,
      offset: Offset(2.0, 2.0),
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
