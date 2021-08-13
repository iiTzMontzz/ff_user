import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ff_user/models_folder/direction_details.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_petshop/pet_shop_search.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_user/user_search.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_vet/vet_search.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/helper_method.dart';
import 'package:ff_user/shared_folder/_buttons/divider.dart';
import 'package:ff_user/shared_folder/_buttons/main_button.dart';
import 'package:ff_user/shared_folder/_constants/progressDialog.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class _RideRequestState extends State<RideRequest>
    with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Position currentPosition;
  DirectionDetails tripDirectionDetails;
  DatabaseReference tripRef;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  double mapPadding = 0;
  double searchSheet = 285;
  double tripDetailSheet = 0;
  double loadingTrip = 0;
  bool showTopnavi = true;
  bool isRequest = true;
  var geolocator = Geolocator();

  @override
  void initState() {
    super.initState();
    HelperMethod.getcurrentUserInfo();
  }

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
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context).popAndPushNamed('/wrapper');
                      } else {
                        //Second Argument RESET APP
                        resetapp();
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

          //Search Page Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: getProportionateScreenHeight(searchSheet),
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
                            showtripDetailsheet();
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
                                SizedBox(
                                    width: getProportionateScreenWidth(10)),
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
                              var response = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          VetSearch()));
                              if (response == 'NearestVet') {
                                showtripDetailsheet();
                              }
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
                                      fontSize:
                                          getProportionateScreenHeight(12),
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
                              var response = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PetStoreSearch()));
                              if (response == 'PetStore') {
                                showtripDetailsheet();
                              }
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
                                      fontSize:
                                          getProportionateScreenHeight(12),
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
          ),

          //Trip Detail SHeet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: getProportionateScreenHeight(tripDetailSheet),
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
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.green[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/man-carrying-a-dog-with-a-belt-to-walk.png',
                                height: getProportionateScreenHeight(50),
                                width: getProportionateScreenWidth(50),
                              ),
                              SizedBox(width: getProportionateScreenWidth(16)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (tripDirectionDetails != null)
                                        ? tripDirectionDetails.durationText
                                        : '',
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          getProportionateScreenHeight(20),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    (tripDirectionDetails != null)
                                        ? tripDirectionDetails.distanceText
                                        : '',
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          getProportionateScreenHeight(26),
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                (tripDirectionDetails != null)
                                    ? 'Php${HelperMethod.estimatedFare(tripDirectionDetails)}'
                                    : '',
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: getProportionateScreenHeight(20),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(22)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyBillAlt,
                              size: getProportionateScreenHeight(18),
                              color: Colors.green[400],
                            ),
                            SizedBox(width: getProportionateScreenWidth(16)),
                            Text(
                              'Cash',
                              style: TextStyle(fontFamily: 'Muli'),
                            ),
                            SizedBox(width: getProportionateScreenWidth(5)),
                            Icon(Icons.keyboard_arrow_down,
                                color: Colors.grey,
                                size: getProportionateScreenHeight(16)),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      //------>//Button for Driver Request
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: MainButton(
                          title: 'Proceed',
                          color: Colors.blue[400],
                          onpress: () {
                            showLoadingTrip();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Finding Driver Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: getProportionateScreenHeight(loadingTrip),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(20)),
                      SizedBox(
                        width: double.infinity,
                        child: TextLiquidFill(
                          text: 'Finding Your Driver.....',
                          waveColor: Colors.greenAccent[400],
                          boxBackgroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: getProportionateScreenHeight(24),
                            fontFamily: 'Muli',
                            fontWeight: FontWeight.bold,
                          ),
                          boxHeight: getProportionateScreenHeight(40),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      GestureDetector(
                        onTap: () {
                          //Cancel Request
                          cancelRequest();
                        },
                        child: Container(
                          height: getProportionateScreenHeight(50),
                          width: getProportionateScreenWidth(50),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          child: Icon(Icons.close, size: 25),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(15)),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: getProportionateScreenHeight(14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Loading Trip UI'
  void showLoadingTrip() {
    setState(() {
      tripDetailSheet = 0;
      loadingTrip = 250;
      mapPadding = 250;
      showTopnavi = false;
    });
    createTripRequest();
  }

//Show Trip SHeet
  void showtripDetailsheet() async {
    await getDirections();
    setState(() {
      searchSheet = 0;
      tripDetailSheet = 225;
      mapPadding = 225;
      isRequest = false;
    });
  }

  //Reset App
  void resetapp() {
    setState(() {
      polylineCoordinates.clear();
      _polylines.clear();
      _markers.clear();
      _circles.clear();
      tripDetailSheet = 0;
      loadingTrip = 0;
      searchSheet = 285;
      mapPadding = 285;
      isRequest = true;
      showTopnavi = true;
    });
    setupPositionLocator();
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
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 90));
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
      fillColor: Colors.redAccent[700],
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

//Create Trip Request in database
  void createTripRequest() {
    tripRef = FirebaseDatabase.instance.reference().child('rideRequest').push();
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    Map pickupMap = {
      'lat': pickup.lat.toString(),
      'lng': pickup.lng.toString(),
    };

    Map destinationMap = {
      'lat': destination.lat.toString(),
      'lng': destination.lng.toString(),
    };

    Map tripMap = {
      'date_created': DateTime.now().toString(),
      'passenger_id': currentuser.uid,
      'name': currentUserinfo.fullname,
      'phone': currentUserinfo.phone,
      'pickup_address': pickup.placename,
      'destination_address': destination.placename,
      'location': pickupMap,
      'destination': destinationMap,
      'payment_method': 'Cash',
      'driver_id': 'pending',
      'status': 'Pending',
    };

    tripRef.set(tripMap);
    tripRef.onValue.listen((event) async {});
  }

  //Cancel TripRequest
  void cancelRequest() {
    tripRef.remove();
    resetapp();
  }
}
