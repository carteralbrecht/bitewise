import 'dart:typed_data';
import 'dart:ui' as ui;
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
  Uint8List markerIcon;
  String _mapStyle;

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
    ByteData data = await rootBundle.load('assets/pin.png');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 120, targetHeight: 130);
    ui.FrameInfo fi = await codec.getNextFrame();
    markerIcon = (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void getUserLocation() async {
    Position result = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
        icon: BitmapDescriptor.fromBytes(markerIcon),
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
          zoom: 15.0,
        ),
        markers: _createMarkers(),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
      DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.05,
        maxChildSize: 1,
        builder: (BuildContext context, myScrollController) {
          return Container(
            padding: EdgeInsets.only(top: 10),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
            ),
            child: ListView.builder(
              controller: myScrollController,
              itemCount: restaurantsNearUser.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 10,
                        width: 50,
                        margin: EdgeInsetsDirectional.only(top: 0, bottom: 0),
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(228, 236, 238, 1),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ));
                }
                return new FlatButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestaurantPage(
                                      restaurantsNearUser[index - 1])))
                        },
                    child: RestaurantListTile(restaurantsNearUser[index - 1],
                        restaurantDistances[index - 1]));
              },
            ),
          );
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(228, 236, 238, 1),
        elevation: 0,
        title: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
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
        leading: IconButton(
          icon: Icon(Icons.fastfood),
          color: Colors.grey,
          onPressed: () {
            Navigator.pushNamed(context, '/test');
          },
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
                  color: Colors.grey,
                ),
              )),
        ],
      ),
      body: _homePage != null ? _homePage : Center(
        // Display Progress Indicator
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(250,202,51,1))
        ),
      ),
    );
  }
}
