import 'dart:async';
import 'package:ff_user/models_folder/direction_details.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_petshop/pet_shop_search.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_user/user_search.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_vet/vet_search.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/helper_method.dart';
import 'package:ff_user/shared_folder/_buttons/divider.dart';
import 'package:ff_user/shared_folder/_constants/progressDialog.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

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
  DirectionDetails tripDirectionDetails;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  double mapPadding = 0;
  double screensheet = 285;
  bool showTopnavi = true;
  bool isRequest = true;
  var geolocator = Geolocator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            initialCameraPosition: initialPosition,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: _polylines,
            markers: _markers,
            circles: _circles,
            onMapCreated: onMapCreated,
          ),

          //Top NAvigation
          (showTopnavi)
              ? Positioned(
                  top: 44,
                  left: 18,
                  child: GestureDetector(
                    onTap: () {
                      if (isRequest) {
                        Navigator.of(context).popAndPushNamed('/wrapper');
                      } else {
                        //Second Argument RESET APP
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7))
                          ]),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Icon(
                          (isRequest) ? Icons.arrow_back : Icons.arrow_back_ios,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                )
              : Positioned(
                  child: Container(
                    height: 0,
                  ),
                ),
          //Search Page
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: getProportionateScreenHeight(screensheet),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(5)),
                    Text(
                      'Hey There!',
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    Text(
                      'Where are we heading?',
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    GestureDetector(
                      onTap: () async {
                        var response = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserSearch()));
                        if (response == 'getDirections') {
                          await getDirections();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              Text(
                                'Input Destination',
                                style: TextStyle(fontFamily: 'Muli'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Row(
                      children: [
                        Icon(
                          OMIcons.pets,
                          color: Colors.grey,
                        ),
                        SizedBox(width: getProportionateScreenWidth(12)),
                        GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    VetSearch()));
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Veterinary',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          getProportionateScreenHeight(16)),
                                ),
                                SizedBox(
                                    height: getProportionateScreenHeight(3)),
                                Text(
                                  'Pick veterinary near you',
                                  style: TextStyle(
                                    fontFamily: 'Muli',
                                    fontSize: getProportionateScreenHeight(12),
                                    color: Colors.grey[400],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    CustomDivider(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Row(
                      children: [
                        Icon(
                          OMIcons.shop,
                          color: Colors.grey,
                        ),
                        SizedBox(width: getProportionateScreenWidth(12)),
                        GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PetStoreSearch()));
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pet Shop',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          getProportionateScreenHeight(16)),
                                ),
                                SizedBox(
                                    height: getProportionateScreenHeight(3)),
                                Text(
                                  'Pick pet shop near you',
                                  style: TextStyle(
                                    fontFamily: 'Muli',
                                    fontSize: getProportionateScreenHeight(12),
                                    color: Colors.grey[400],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    CustomDivider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //onMapCreated
  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
    setState(() {
      mapPadding = getProportionateScreenHeight(285);
    });
    setupPositionLocator();
  }

  //Setting up current Location
  void setupPositionLocator() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 16);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    await HelperMethod.findCoordinateAddress(position, context);
  }

  //Getting Direction Drawing Polylines
  Future<void> getDirections() async {
    var pickUp = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickupLatLng = LatLng(pickUp.lat, pickUp.lng);
    var destinationLatLng = LatLng(destination.lat, destination.lng);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Getting Directions.....'));
    var thisDetails =
        await HelperMethod.getDirectionDetails(pickupLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetails = thisDetails;
    });
    Navigator.of(context).pop();
    PolylinePoints polylinepoints = PolylinePoints();
    List<PointLatLng> result =
        polylinepoints.decodePolyline(thisDetails.encodedPoints);
    polylineCoordinates.clear();
    if (result.isNotEmpty) {
      //Looping through the encoded points to convert into polyline points
      result.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyID'),
        color: Colors.blueAccent[700],
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.buttCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });
    //Fitting polyline points in the map after picking a destination adrress
    LatLngBounds bounds;
    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
      );
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: pickupLatLng,
        northeast: destinationLatLng,
      );
    }
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    //Markers
    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickUp.placename, snippet: 'My Location'),
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
          title: destination.placename, snippet: 'Destination Location'),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });
    //Cricles
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: Colors.green,
    );
    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.purpleAccent,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: Colors.purpleAccent,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }
}
