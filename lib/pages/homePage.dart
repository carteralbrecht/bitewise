import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.lightBlue[100],
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
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                  color: Colors.black,
                ),
              )),
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
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.lightGreen[100],
                height: 350,
                alignment: Alignment.center,
                child: Text(
                  'Map',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'home page',
                style: TextStyle(color: Colors.black, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ]),
      ),
    );
  }
}
