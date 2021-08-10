import 'package:ff_user/models_folder/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final CameraPosition initialPosition = CameraPosition(
  target: LatLng(7.1907, 125.4553),
  zoom: 14.4746,
);
FirebaseUser currentuser;
UserData currentUserinfo;

const placesprediction =
    'https://maps.googleapis.com/maps/api/place/details/json?placeid=placesidhere&key=androidID';

const autocomplete =
    'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=placename&location=7.1907,125.4553&radius=49436.8284&key=androidID&sessiontoken={uuid.v4()}&components=country:ph&regions=postal_code:8000';

const geocode =
    'https://maps.googleapis.com/maps/api/geocode/json?latlng={position.latitude},{position.longitude}&key=androidID';
const directions =
    'https://maps.googleapis.com/maps/api/directions/json?origin={startPosition.latitude},{startPosition.longitude}&destination={endPosition.latitude},{endPosition.longitude}&mode=driving&key=apiKey';
