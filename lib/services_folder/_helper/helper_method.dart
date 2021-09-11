import 'dart:convert';
import 'dart:math';
import 'package:ff_user/models_folder/history.dart';
import 'package:ff_user/models_folder/user_data.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:ff_user/models_folder/address.dart';
import 'package:ff_user/models_folder/direction_details.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/request_helper.dart';
import 'package:ff_user/shared_folder/_global/key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HelperMethod {
  //Get user Information
  static void getcurrentUserInfo(context) async {
    currentuser = await FirebaseAuth.instance.currentUser();
    String uid = currentuser.uid;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users/$uid');
    userRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        currentUserinfo = UserData.fromSnapshot(snapshot);
        print('HELOOO MY NAME ISSSSSS>>>>>>>>>>>>>>>>>>>' +
            currentUserinfo.fullname);
        getHistory(context, currentUserinfo.uid);
      }
    });
  }

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

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    }
    return placeAddress;
  }

  //Gettin Trip request from the Directions APi
  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$androidID';
    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];
    return directionDetails;
  }

  //Fare Computation
  static int estimatedFare(DirectionDetails directionDetails) {
    double baseFare = 40;
    double perKm = (directionDetails.distanceValue / 100) * 3;
    double perMin = (directionDetails.durationValue / 60) * 2;

    double totalFare = baseFare + perKm + perMin;
    return totalFare.truncate();
  }

  //Random Number Generator
  static double numberGenerator(int max) {
    var randomNumber = Random();
    int randInt = randomNumber.nextInt(max);

    return randInt.toDouble();
  }

//Sending Request to Driver
  static void sendFcm(String token, context, String tripId) async {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': servertoken,
    };
    Map notoficationMap = {
      'body': 'Click to View.',
      'title': 'New Trip Request',
    };
    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'Trip_Id': tripId,
    };

    Map bodyMap = {
      'notification': notoficationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: headerMap, body: jsonEncode(bodyMap));
    print(response.body);
  }

//get history info
  static void getHistory(context, String id) {
    DatabaseReference historyRef =
        FirebaseDatabase.instance.reference().child('users/$id/history');
    historyRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);

        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.reference().child('rideRequest/$key');
      historyRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistory(history);
        }
      });
    }
  }

  static String formatMyDate(String datestring) {
    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate =
        '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)}';

    return formattedDate;
  }
}
