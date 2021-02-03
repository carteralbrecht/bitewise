import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/pages/profilePage.dart';
import 'package:bitewise/models/menuItem.dart';

class RestaurantPage extends StatefulWidget {

  final Restaurant restaurant;
  const RestaurantPage(this.restaurant);


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

  Color c1 = const Color(0xE4ECEE);
  Widget restInfo() {
    return Container (
        margin: const EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // height: 70,
        // width: 70,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.restaurant.name, style: TextStyle(color: Colors.black, fontSize: 20)),
              Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.yellow[600],
                    textColor: Colors.black,
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "Sort",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  FlatButton(
                    color: Colors.yellow[600],
                    textColor: Colors.black,
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "Filter",
                    ),
                  )
                ],
              )
            ]
        )
    );
  }

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

  Widget _body() {
    return Stack(
      children: <Widget>[restInfo()]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // title: Text('bitewise',
        //   style: TextStyle(color: Colors.black, fontSize: 25)),
        // leading: IconButton(
        //   icon: Icon(Icons.fastfood),
        //   color: Colors.black,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        actions: <Widget>[
              Container(
                height: 35,
                width: 35,
                decoration: new BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () async {
                    var user = await _auth.getUser();
                    if (user == null)
                    {
                      Navigator.pushNamed(context, '/signin');
                      
                    }
                    else
                    {
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => ProfilePage()
                        )
                      );
                    }
                    
                  },
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                )
              ),
            ],
        centerTitle: true,
      ),
      body: _body(),
    );
  }
}
