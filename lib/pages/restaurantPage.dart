import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';

class RestaurantPage extends StatefulWidget {
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  ButtonStyle rateButton = new ButtonStyle();
  final AuthService _auth = AuthService();

  // @override
  // void initState() {
  //   getUserLocation();
  //   super.initState();
  // }

  Widget _dishList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // if (i.isOdd) return Divider();

        return Card(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Stack(
              children: <Widget> [
              Text('Dish $i', style: TextStyle(color: Colors.black, fontSize: 20)),
              Row(
              children: <Widget>[
                Column(
                  children: <Widget> [Text('  Dish $i description', style: TextStyle(color: Colors.black38, fontSize: 15))]),
                Padding(padding: EdgeInsets.all(32.0)),
                Column(
                  children: <Widget> [
                    TextButton(
                        child: Text("Rate", style: TextStyle(color: Colors.black)),
                        onPressed: ( /*rate modal*/ ) {},
                        style: TextButton.styleFrom(backgroundColor: Colors.yellow[600])
                    )
                ])
              ],
        )])));
    });
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
      body: _dishList(),
    );
  }
}
