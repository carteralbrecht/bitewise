import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  @override
  void initState() {
    getUserLocation();
    getRestaurantsNearby();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getUserLocation() async {
    Position result = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(result);
    setState(() {
      currentLocation = result;
      
    });
  }

  void getRestaurantsNearby() async {
    var restaurants = await searchRestaurantsGeo(
        Position(longitude: -77.17103, latitude: 39.114805),
        2);
    

    List<Restaurant> resultsNear = new List<Restaurant>();
    
    
    for (Restaurant restaurant in restaurants) {
      resultsNear.add(restaurant);
    }
    setState(() {
      restaurantsNearUser = resultsNear;

      // create the map when restaurants are finished being fetched
      _homePage = createMap();
    });
  }

  Set<Marker> _createUserMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("Current Location"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: "Current Location"),
      )
    ].toSet();
  }

  Stack createMap() {
    return Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 11.0,
        ),
        markers: _createUserMarker(),
      ),
      DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.05,
        maxChildSize: 1,
        builder: (BuildContext context, myScrollController) {
          return Container(
            padding: EdgeInsets.only(top:10),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius:  BorderRadius.only(topLeft:Radius.circular(20.0), topRight:Radius.circular(20.0)),
            ),
            child: ListView.builder(
              controller: myScrollController,
              itemCount: restaurantsNearUser.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    alignment:Alignment.topCenter,
                    child: Container(
                      height: 10,
                      width: 50,
                      margin: EdgeInsetsDirectional.only(top:0, bottom:0),
                      decoration: new BoxDecoration(
                        color: Color.fromRGBO(228,236,238,1),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    )
                  );
                }
                return new RestaurantListTile(restaurantsNearUser[index-1]);
              },
            ),
          );
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color.fromRGBO(228,236,238,1),
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
                  Text('Search', style: TextStyle(fontSize: 20, color: Colors.grey)),
                ]
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.fastfood),
              color: Colors.grey,
              onPressed: () {
                // Navigator.pushNamed(context, '/test');
              },
            ),
            actions: <Widget>[
              Container(
                height:35,
                width: 35,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, '/signin');
                  },
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                )
              ),
            ],
            
          ),
      body: _homePage,
    ));
  }
}

// Temporary until RestaurantQuery is hooked up
// var restaurantList = [RestaurantListTile("Chili's", "this is the chilis address, hooray! gotta make it really long"),
//                       RestaurantListTile("Chic Fil A", "this is the Chic Fil A address, hooray! gotta make it really long"),
//                       RestaurantListTile("Dominoes", "this is the Dominoes address, hooray! gotta make it really long"),
//                       RestaurantListTile("Waffle House", "this is the Waffle House address, hooray! gotta make it really long"),
//                       RestaurantListTile("Chili's", "this is the chilis address, hooray! gotta make it really long"),
//                       RestaurantListTile("Chic Fil A", "this is the Chic Fil A address, hooray! gotta make it really long"),
//                       RestaurantListTile("Dominoes", "this is the Dominoes address, hooray! gotta make it really long"),
//                       RestaurantListTile("Waffle House", "this is the Waffle House address, hooray!, gotta make it really long")
//                     ];
