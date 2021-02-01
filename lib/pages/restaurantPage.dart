import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/pages/profilePage.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/components/ratingModal.dart';

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
                        onPressed: () {
                          showDialog(
                                  context: context,
                                  builder: (_) => RatingModal("test", "test"),
                                  barrierDismissible: true);
                        },
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
            Navigator.pop(context);
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
                    color: Colors.grey,
                  ),
                )
              ),
            ],
        centerTitle: true,
      ),
      body: _dishList(),
    );
  }
}
