import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    // upon app load, sign in to anon user
    print('calling signInOnLoad');
    _auth.signInOnLoad().then((value) {
      print('finished signInOnLoad: ' + value.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: <Widget> [
          Container(
              color: Colors.lightGreen[200],
              child: Text('Map', style: TextStyle(fontSize:20, color: Colors.black,), textAlign: TextAlign.center,),
              alignment: Alignment.center,
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: .8,
            builder: (BuildContext context, myscrollController) {
              return Container(
                color: Colors.lightBlue[200],
                child: ListView.builder(
                  controller: myscrollController,
                  itemCount: 25,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return AppBar(
                        title: Text('Search', style:TextStyle(fontSize: 20, color: Colors.black)),
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
                            )
                          ),
                        ],
                      );
                    }
                    return ListTile(
                      title: Text(
                        // place holder for restaurants nearby
                        'Dish $index',
                        style: TextStyle(color: Colors.black54),
                    ));
                  },
                ),
              );
            },
          ),
        ]
      ),
    );
  }
}
