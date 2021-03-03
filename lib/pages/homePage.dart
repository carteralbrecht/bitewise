import 'dart:ui';
import 'package:bitewise/util/geoUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:bitewise/global.dart' as global;
import 'package:bitewise/pages/restaurantPage.dart';
import 'package:bitewise/services/auth.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/util/restaurantSearchUtil.dart';
import 'package:bitewise/models/restaurant.dart';
import '../components/restaurantListTile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  GoogleMapController mapController;
  Position currentLocation;
  Stack _homePage;
  var restaurantsNearUser;
  var restaurantDistances;
  BitmapDescriptor pinImage;
  String _mapStyle;
  bool isSheetMax = false;

  @override
  void initState() {
    setPinImage();
    getUserLocation();
    getRestaurantsNearby();
    rootBundle.loadString('assets/MapStyle.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void setPinImage() async {
    pinImage = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(25, 35)),
        'assets/pin.png');
  }

  void getUserLocation() async {
    Position result = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      currentLocation = result;
    });
  }

  void getRestaurantsNearby() async {
    // Don't fetch restaurants until we have a current location for the user
    while (currentLocation == null) {
      await Future.delayed(Duration(milliseconds: 500));
    }

    var restaurants = await RestaurantSearchUtil.searchByGeo(currentLocation, 2);

    List<Restaurant> resultsNear = new List<Restaurant>();
    List<double> restDistances = new List<double>();

    for (Restaurant restaurant in restaurants) {
      resultsNear.add(restaurant);
      restDistances.add(await GeoUtil.distanceToRestaurant(currentLocation, restaurant));
    }

    setState(() {
      restaurantsNearUser = resultsNear;
      restaurantDistances = restDistances;
      // create the map when restaurants are finished being fetched
      _homePage = createMap();
    });
  }

  Set<Marker> _createMarkers() {
    final Set<Marker> markersSet = {};

    for (Restaurant restaurant in restaurantsNearUser) {
      markersSet.add(Marker(
        markerId: MarkerId(restaurant.name),
        position: LatLng(restaurant.geo.latitude, restaurant.geo.longitude),
        infoWindow: InfoWindow(
            title: restaurant.name,
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantPage(restaurant)))
                }),
        icon: pinImage,
      ));
    }

    return markersSet;
  }

  Stack createMap() {
    return Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 13.0,
        ),
        markers: _createMarkers(),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
      DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.05,
        maxChildSize: 1,
        builder: (BuildContext context, _scrollController) {
          _scrollController.addListener(() {
            setState(() {
              isSheetMax = _scrollController.offset > 0;
            });
            print(_scrollController.offset.toString());
          });
          return Container(
            padding: EdgeInsets.only(top: 10),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: isSheetMax ? BorderRadius.zero : BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0)),
            ),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: restaurantsNearUser.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 5,
                        width: 60,
                        margin: EdgeInsetsDirectional.only(top: 0, bottom: 5),
                        decoration: new BoxDecoration(
                          color: global.accentGrayDark,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ));
                }
                return new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestaurantPage(
                                        restaurantsNearUser[index - 1])))
                          },
                      child: RestaurantListTile(restaurantsNearUser[index - 1],
                          restaurantDistances[index - 1])
                    ),
                    Divider(
                      color: global.accentGrayLight,
                      height: 5,
                      thickness: 5,
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: global.mainColor,
          elevation: 0,
          title: Container(
            margin: EdgeInsets.only(left: 0, right: 20),
            padding: EdgeInsets.only(left: 10, right: 10),
            height: 40,
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.search, size: 26.0, color: Colors.grey),
                  Text('Search',
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                ]),
          ),
          actions: <Widget>[
            Container(
                height: 35,
                width: 35,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    if (global.user == null) {
                      Navigator.pushNamed(context, '/signin');
                    } else {
                      Navigator.pushNamed(context, '/profile');
                    }
                  },
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: global.mainColor,
                  ),
                )),
          ],
        ),
        body: _homePage,
      ),
    );
  }
}
