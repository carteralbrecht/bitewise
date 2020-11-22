import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class RestaurantPage extends StatefulWidget {
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final AuthService _auth = AuthService();
  Stack _restaurantPage;

  // @override
  // void initState() {
  //   getUserLocation();
  //   super.initState();
  // }

  Stack dishList() {
    return Stack(children: <Widget>[
      DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.1,
        maxChildSize: .8,
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
    return new Scaffold(
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
        centerTitle: true,
      ),
      body: _restaurantPage,
    );
  }
}
