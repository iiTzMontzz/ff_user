import 'dart:async';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequest extends StatefulWidget {
  final String rideType;
  const RideRequest({this.rideType});

  @override
  _RideRequestState createState() => _RideRequestState();
}

class _RideRequestState extends State<RideRequest> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Position currentPosition;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  var geolocator = Geolocator();
  String appState = 'Normal';
  double loadingTrip = 0;
  double mapPadding = 0;
  double searchSheet = 300;
  double tripSheet = 0;
  double reideDetailSheet = 0;
  bool nearbyKeyisLoaded = false;
  bool isRequestingLocationDetails = false;
  bool isRequest = true;
  bool showTopnavi = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            initialCameraPosition: initialPosition,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: onMapCreated,
          )
        ],
      ),
    );
  }

  //onMapCreated
  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
    setState(() {
      mapPadding = 300;
    });
  }
}
