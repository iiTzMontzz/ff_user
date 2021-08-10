import 'package:connectivity/connectivity.dart';
import 'package:ff_user/models_folder/address.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/request_helper.dart';
import 'package:ff_user/shared_folder/_global/key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HelperMethod {
  //Getting the formated address from the http request of current address
  static Future<String> findCoordinateAddress(
      Position position, context) async {
    String placeAddress = '';
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$androidID';
    var response = await RequestHelper.getRequest(url);
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = new Address();
      pickupAddress.lat = position.latitude;
      pickupAddress.lng = position.longitude;
      pickupAddress.placename = placeAddress;

      // Provider.of<AppData>(context, listen: false)
      //     .updatePickupAddress(pickupAddress);
    }
    return placeAddress;
  }
}
