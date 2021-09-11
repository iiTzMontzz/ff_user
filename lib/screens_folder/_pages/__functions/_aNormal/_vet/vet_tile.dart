import 'package:ff_user/models_folder/address.dart';
import 'package:ff_user/models_folder/veterinary.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/request_helper.dart';
import 'package:ff_user/shared_folder/_constants/progressDialog.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/key.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

class VetTile extends StatelessWidget {
  final Veterinaries vet;
  VetTile({this.vet});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        getPlaceDetails(vet.placeID, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              children: [
                Icon(
                  OMIcons.locationOn,
                  color: Colors.grey[350],
                ),
                SizedBox(width: getProportionateScreenWidth(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vet.vetname,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: 'Muli',
                              fontSize: getProportionateScreenHeight(18),
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: getProportionateScreenHeight(2)),
                      Text(
                        vet.vicinity,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: getProportionateScreenHeight(12),
                            color: Colors.grey[850]),
                      ),
                      SizedBox(height: getProportionateScreenHeight(2)),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }

  void getPlaceDetails(String placeId, context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Loading....',
            ));
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$androidID';
    var response = await RequestHelper.getRequest(url);

    Navigator.of(context).pop();

    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Address thisPlace = new Address();
      thisPlace.placename = response['result']['name'];
      thisPlace.placeID = placeId;
      thisPlace.lat = response['result']['geometry']['location']['lat'];
      thisPlace.lng = response['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false)
          .updateDestinationAddress(thisPlace);
      print('HELOO >>>>>>>>> ' + thisPlace.placename);

      Navigator.of(context).pop('NearestVet');
    }
  }
}
