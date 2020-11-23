import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  GoogleMapController mapController;
  Position currentLocation;
  Stack _homePage;

  @override
  void initState() {
    getUserLocation();
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
        minChildSize: 0.1,
        maxChildSize: 0.8,
        builder: (BuildContext context, myScrollController) {
          return Container(
            color: Colors.lightBlue[200],
            child: ListView.builder(
              controller: myScrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return AppBar(
                    title: Text('Search',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    backgroundColor: Colors.grey[300],
                    elevation: 0,
                    centerTitle: true,
                    actions: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              // Search bar implementation. Probably showSearch()
                            },
                            child: Icon(
                              Icons.search,
                              size: 26.0,
                              color: Colors.black,
                            ),
                          )),
                    ],
                  );
                }
                if (index.isOdd) return Divider();
                return ListTile(
                  title: Text(
                    // placeholder for restaurants nearby
                    'Restaurant $index',
                    style: TextStyle(color: Colors.black54)),
                  onTap: () {
                    Navigator.pushNamed(context, '/restaurant');
                  }
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
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        elevation: 0,
        title: Text('bitewise',
            style: TextStyle(color: Colors.black, fontSize: 25)),
        leading: IconButton(
          icon: Icon(Icons.fastfood),
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, '/test');
          },
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              )),
        ],
        centerTitle: true,
      ),
      body: _homePage,
    ));
  }
}
