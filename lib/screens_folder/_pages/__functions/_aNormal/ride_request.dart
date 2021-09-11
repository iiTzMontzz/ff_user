import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ff_user/models_folder/direction_details.dart';
import 'package:ff_user/models_folder/nearby_drivers.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/_petshop/pet_shop_search.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/_user/user_search.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_aNormal/_vet/vet_search.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_widgets/car_type.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_widgets/no_driver_available.dart';
import 'package:ff_user/screens_folder/_pages/__functions/_widgets/payments_dialog.dart';
import 'package:ff_user/services_folder/_database/app_data.dart';
import 'package:ff_user/services_folder/_helper/fire_helper.dart';
import 'package:ff_user/services_folder/_helper/helper_method.dart';
import 'package:ff_user/shared_folder/_buttons/divider.dart';
import 'package:ff_user/shared_folder/_buttons/main_button.dart';
import 'package:ff_user/shared_folder/_constants/progressDialog.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:ff_user/shared_folder/_global/tripVariables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
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
  StreamSubscription<Event> tripSubscription;
  GoogleMapController mapController;
  Position currentPosition;
  DirectionDetails tripDirectionDetails;
  BitmapDescriptor nearbyDriverIcon;
  DatabaseReference tripRef;
  List<LatLng> polylineCoordinates = [];
  List<NearbyDriver> availableDrivers;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  String appState = 'Normal';
  double mapPadding = 0;
  double searchSheet = 310;
  double tripDetailSheet = 0;
  double loadingTrip = 0;
  double tripSheet = 0;
  bool showTopnavi = true;
  bool isRequest = true;
  bool nearbyKeyisLoaded = false;
  bool isRequestingLocationDetails = false;
  bool startGeofire;
  var geolocator = Geolocator();

  @override
  void initState() {
    super.initState();
    HelperMethod.getcurrentUserInfo(context);
    if (geoStatus == null) {
      startGeofire = true;
    } else {
      startGeofire = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
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

          //Top NAvigation --------------------------------------->
          (showTopnavi)
              ? Positioned(
                  top: 44,
                  left: 18,
                  child: GestureDetector(
                    onTap: () {
                      if (isRequest) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/wrapper');
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

          //Search Page Sheet ------------------------------------>
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
                    children: [
                      Expanded(
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
                                          width:
                                              getProportionateScreenWidth(10)),
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
                                SizedBox(
                                    width: getProportionateScreenWidth(12)),
                                GestureDetector(
                                  onTap: () async {
                                    var response = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                VetSearch()));
                                    if (response == 'NearestVet') {
                                      showtripDetailsheet();
                                    }
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Veterinary',
                                          style: TextStyle(
                                              fontFamily: 'Muli',
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      16)),
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    3)),
                                        Text(
                                          'Pick veterinary near you',
                                          style: TextStyle(
                                            fontFamily: 'Muli',
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    12),
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
                                SizedBox(
                                    width: getProportionateScreenWidth(12)),
                                GestureDetector(
                                  onTap: () async {
                                    var response = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PetStoreSearch()));
                                    if (response == 'PetStore') {
                                      showtripDetailsheet();
                                    }
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pet Shop',
                                          style: TextStyle(
                                              fontFamily: 'Muli',
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      16)),
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    3)),
                                        Text(
                                          'Pick pet shop near you',
                                          style: TextStyle(
                                            fontFamily: 'Muli',
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    12),
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
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Trip Detail SHeet ------------------------------------>
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
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.green[100],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/man-carrying-a-dog-with-a-belt-to-walk.png',
                                      height: getProportionateScreenHeight(50),
                                      width: getProportionateScreenWidth(50),
                                    ),
                                    SizedBox(
                                        width: getProportionateScreenWidth(16)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (tripDirectionDetails != null)
                                              ? tripDirectionDetails
                                                  .durationText
                                              : '',
                                          style: TextStyle(
                                            fontFamily: 'Muli',
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    20),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          (tripDirectionDetails != null)
                                              ? tripDirectionDetails
                                                  .distanceText
                                              : '',
                                          style: TextStyle(
                                            fontFamily: 'Muli',
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    26),
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
                                        fontSize:
                                            getProportionateScreenHeight(20),
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
                                  SizedBox(
                                      width: getProportionateScreenWidth(16)),
                                  Text(
                                    'Cash',
                                    style: TextStyle(fontFamily: 'Muli'),
                                  ),
                                  SizedBox(
                                      width: getProportionateScreenWidth(5)),
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
                                onpress: () async {
                                  var response = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          CarType());
                                  if (response == 'Normal') {
                                    print("RESPONSE >> Normal");
                                    if (startGeofire == true) {
                                      startGeofireListener();
                                      setState(() {
                                        startGeofire = false;
                                        geoStatus = false;
                                      });
                                    }
                                    setState(() {
                                      appState = 'Requesting';
                                    });
                                    showLoadingTrip();
                                    availableDrivers =
                                        FireHelper.nearbyDriverlist;
                                    findDriver();
                                  } else if (response == 'Medium') {
                                    print("RESPONSE >> Medium");
                                    if (startGeofire == true) {
                                      startGeofireListener();
                                      setState(() {
                                        startGeofire = false;
                                        geoStatus = false;
                                      });
                                    }
                                    setState(() {
                                      appState = 'Requesting';
                                    });
                                    showLoadingTrip();
                                    availableDrivers =
                                        FireHelper.nearbyDriverlist;
                                    findDriver();
                                  } else if (response == 'Delux') {
                                    print("RESPONSE >> Delux");
                                    if (startGeofire == true) {
                                      startGeofireListener();
                                      setState(() {
                                        startGeofire = false;
                                        geoStatus = false;
                                      });
                                    }
                                    setState(() {
                                      appState = 'Requesting';
                                    });
                                    showLoadingTrip();
                                    availableDrivers =
                                        FireHelper.nearbyDriverlist;
                                    findDriver();
                                  } else {
                                    resetapp();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Finding Driver Sheet --------------------------------->
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
                    children: [
                      Expanded(
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
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Trip Detail Sheet ------------------------------------>
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: getProportionateScreenHeight(tripSheet),
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
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: getProportionateScreenHeight(5)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tripStatusDisplay,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Muli',
                                    fontSize: getProportionateScreenHeight(20),
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            CustomDivider(),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Text(
                              carDetails,
                              style: TextStyle(
                                fontFamily: 'Muli',
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              driverName,
                              style: TextStyle(
                                fontFamily: 'Muli',
                                fontSize: getProportionateScreenHeight(20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            CustomDivider(),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //Call
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: getProportionateScreenHeight(50),
                                      width: getProportionateScreenWidth(50),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      child: Icon(Icons.call),
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(10)),
                                    Text(
                                      'Call',
                                      style: TextStyle(
                                          fontFamily: 'Muli',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                //Driver Info
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: getProportionateScreenHeight(50),
                                      width: getProportionateScreenWidth(50),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      child: Icon(Icons.list),
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(10)),
                                    Text(
                                      'Driver Info',
                                      style: TextStyle(
                                          fontFamily: 'Muli',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                //Cancel
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        tripRef.child('status').set('Canceled');
                                        resetapp();
                                      },
                                      child: Container(
                                        height:
                                            getProportionateScreenHeight(50),
                                        width: getProportionateScreenWidth(50),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        child: Icon(OMIcons.clear),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(10)),
                                    Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontFamily: 'Muli',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
      tripDetailSheet = 240;
      mapPadding = 240;
      isRequest = false;
    });
  }

//Trip sheet UI
  void showTripsheet() {
    setState(() {
      loadingTrip = 0;
      tripSheet = 310;
      mapPadding = 310;
    });
  }

  //Reset App
  void resetapp() async {
    setState(() {
      polylineCoordinates.clear();
      _polylines.clear();
      _markers.clear();
      _circles.clear();
      tripDetailSheet = 0;
      loadingTrip = 0;
      searchSheet = 310;
      mapPadding = 310;
      isRequest = true;
      showTopnavi = true;
      tripSheet = 0;

      status = '';
      driverName = '';
      driverPhone = '';
      carDetails = '';
      tripStatusDisplay = 'Driver is Arriving';
    });
    setupPositionLocator();
  }

  //onMapCreated
  void onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    mapController = controller;
    setState(() {
      mapPadding = getProportionateScreenHeight(310);
    });
    setupPositionLocator();
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

//Getting Nearby Drivers using Geofire
  void startGeofireListener() {
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 5)
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.lat = map['latitude'];
            nearbyDriver.lng = map['longitude'];
            FireHelper.nearbyDriverlist.add(nearbyDriver);
            if (nearbyKeyisLoaded) {
              updateDriversOnmap();
              print(
                  'FIREHLEPR Entered LENGHT: ${FireHelper.nearbyDriverlist.length}');
            }
            break;

          case Geofire.onKeyExited:
            FireHelper.removeFromlist(map['key']);
            updateDriversOnmap();
            print(
                'FIREHLEPR Exited LENGHT: ${FireHelper.nearbyDriverlist.length}');
            break;

          case Geofire.onKeyMoved:
            // Update your key's / Drivers location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.lat = map['latitude'];
            nearbyDriver.lng = map['longitude'];
            FireHelper.updateNearbyLocation(nearbyDriver);
            updateDriversOnmap();
            print(
                'FIREHLEPR Moved LENGHT: ${FireHelper.nearbyDriverlist.length}');
            break;

          case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
            nearbyKeyisLoaded = true;
            updateDriversOnmap();
            print(
                'FIREHLEPR Query LENGHT: ${FireHelper.nearbyDriverlist.length}');
            break;
        }
      }
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
      'ride_type': widget.rideType,
      'status': 'Pending',
    };
    tripRef.set(tripMap);
    tripSubscription = tripRef.onValue.listen((event) async {
      //Checking if event is null
      if (event.snapshot.value == null) {
        return;
      }
      //get Details
      if (event.snapshot.value['vehicle_detail'] != null) {
        setState(() {
          carDetails = event.snapshot.value['vehicle_detail'].toString();
        });
      }
      //Get Driver Name
      if (event.snapshot.value['driver_name'] != null) {
        setState(() {
          driverName = event.snapshot.value['driver_name'].toString();
        });
      }
      //Get Driver Phone
      if (event.snapshot.value['driver_phone'] != null) {
        setState(() {
          driverPhone = event.snapshot.value['driver_phone'].toString();
        });
      }
      //Check if status is not null
      if (event.snapshot.value['status'] != null) {
        setState(() {
          status = event.snapshot.value['status'].toString();
        });
      }
      //Get and use Driver Location
      if (event.snapshot.value['driver_location'] != null) {
        double driverLat = double.parse(
            event.snapshot.value['driver_location']['lat'].toString());
        double driverLng = double.parse(
            event.snapshot.value['driver_location']['lng'].toString());
        LatLng driverLocation = LatLng(driverLat, driverLng);
        if (status == 'Accepted') {
          updateToPickup(driverLocation);
        } else if (status == 'Arrived') {
          setState(() {
            tripStatusDisplay = 'Driver has arrived';
          });
        } else if (status == 'OnTrip') {
          updateToDestination(driverLocation);
        }
      }
      //if Status is accepted
      if (status == 'Accepted') {
        showTripsheet();
        removeGeofireMarkers();
        DatabaseReference historyRef = FirebaseDatabase.instance
            .reference()
            .child('users/${currentUserinfo.uid}/history/${tripRef.key}');
        historyRef.set(true);
      }
      if (status == 'Ended') {
        if (event.snapshot.value['fare'] != null) {
          int fare = int.parse(event.snapshot.value['fare'].toString());
          var resposne = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PaymentsDialog(fare: fare));

          if (resposne == 'close') {
            tripRef.onDisconnect();
            tripRef = null;
            tripSubscription.cancel();
            tripSubscription = null;
            resetapp();
          }
        }
      }
    });
  }

  //Removing Markers on the map
  void removeGeofireMarkers() {
    setState(() {
      _markers.removeWhere((m) => m.markerId.value.contains('driver'));
    });
  }

//Updatting to destination time
  void updateToDestination(LatLng driverLocation) async {
    if (!isRequestingLocationDetails) {
      isRequestingLocationDetails = true;
      var destination =
          Provider.of<AppData>(context, listen: false).destinationAddress;
      var destinationLatLng = LatLng(destination.lat, destination.lng);
      var thisDetails = await HelperMethod.getDirectionDetails(
          driverLocation, destinationLatLng);
      if (thisDetails == null) {
        return;
      }
      setState(() {
        tripStatusDisplay = 'Arrival Time - ${thisDetails.durationText}';
      });
      isRequestingLocationDetails = false;
    }
  }

  //Update to Pick up location time
  void updateToPickup(LatLng driverLocation) async {
    if (!isRequestingLocationDetails) {
      isRequestingLocationDetails = true;
      var positionLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      var thisDetails = await HelperMethod.getDirectionDetails(
          driverLocation, positionLatLng);
      if (thisDetails == null) {
        return;
      }
      setState(() {
        tripStatusDisplay =
            'Drivers Arrival Time - ${thisDetails.durationText}';
      });
      isRequestingLocationDetails = false;
    }
  }

  //Cancel TripRequest
  void cancelRequest() {
    tripRef.remove();
    resetapp();
    setState(() {
      appState = 'Normal';
    });
  }

  //updating drivers on map
  void updateDriversOnmap() {
    setState(() {
      _markers.clear();
    });
    Set<Marker> tempoMarker = Set<Marker>();
    for (NearbyDriver driver in FireHelper.nearbyDriverlist) {
      LatLng driverPos = LatLng(driver.lat, driver.lng);
      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPos,
        icon: nearbyDriverIcon,
        rotation: HelperMethod.numberGenerator(360),
      );
      tempoMarker.add(thisMarker);
    }
    setState(() {
      _markers = tempoMarker;
    });
  }

  //Create Moving Markers
  void createMarker() {
    if (nearbyDriverIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/pawprint.png')
          .then((icon) {
        nearbyDriverIcon = icon;
      });
    }
  }

//Getting Driver
  void findDriver() {
    if (availableDrivers.length == 0) {
      cancelRequest();
      resetapp();
      noDriverFound();
      return;
    }
    var driver = availableDrivers[0];
    notifyDriver(driver);
    availableDrivers.removeAt(0);
    print(' OYY DARA ANG IMONG DRIVER OHHH' + driver.key);
  }

  //If No Driver/s is found
  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverAvailable());
  }

//Notifying Driver
  void notifyDriver(NearbyDriver nearbyDriver) {
    DatabaseReference driverTripRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${nearbyDriver.key}/newTrip');
    driverTripRef.set(tripRef.key);
    //Getting Driver Token
    DatabaseReference driverTokenref = FirebaseDatabase.instance
        .reference()
        .child('drivers/${nearbyDriver.key}/token');
    driverTokenref.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String driverToken = snapshot.value.toString();
        //Sending Notification to the selected Driver
        HelperMethod.sendFcm(driverToken, context, tripRef.key);
      } else {
        return;
      }
      const oneSeckTick = Duration(seconds: 1);
      Timer.periodic(oneSeckTick, (timer) async {
        //Stopping the timer when the Passenger cancelled the trip request
        if (appState != 'Requesting') {
          driverTripRef.set('Canceled');
          driverTripRef.onDisconnect();
          timer.cancel();
          driverRequestTimedOut = 10;
        }
        driverRequestTimedOut--;
        //If the Driver Accepts the Request
        driverTripRef.onValue.listen((event) {
          if (event.snapshot.value.toString() == 'Accepted') {
            driverTripRef.onDisconnect();
            timer.cancel();
            driverRequestTimedOut = 10;
          }
        });
        if (driverRequestTimedOut == 0) {
          driverTripRef.set('timeout');
          driverTripRef.onDisconnect();
          driverRequestTimedOut = 10;
          timer.cancel();
          //Find New Driver'
          findDriver();
        }
      });
    });
  }
}
