import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitewise/icons/my_flutter_app_icons.dart';

class RestaurantListTile extends StatefulWidget {

  final Restaurant restaurant;
  final double milesAway;
  const RestaurantListTile(this.restaurant, this.milesAway);

  @override
  _RestaurantListTileState createState() => _RestaurantListTileState();
}

class _RestaurantListTileState extends State<RestaurantListTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
                color: Color.fromRGBO(250,202,51,1),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: EdgeInsets.only(left:10,right:10, bottom:10, top:10),
      height: 100,
      child: Card(
        elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.only(left:20, right: 20, top: 10),
          tileColor: Color.fromRGBO(250,202,51,1),
          trailing: Container(
            margin: EdgeInsets.only(left: 20),
            child: _assignIcon(widget.restaurant.cuisines),
          ),
          title: Text(widget.restaurant.name, style: TextStyle(color: Colors.black, fontSize:25, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          subtitle: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: Text(
              widget.milesAway.toStringAsFixed(2) + " Miles", style: TextStyle(fontSize:20)
            ),
          ),
          isThreeLine: true,
        ),
      )
    );
  }

  Icon _assignIcon(List<String> cuisines) {
    if (cuisines.first == "American" || cuisines.first == "Burgers" || cuisines.first == "Bar Food" || cuisines.first == "American (New)")
      return Icon(MyFlutterApp.big_cheeseburger, size: 50, color: Colors.grey);
    else if (cuisines.first == "Sandwiches" || cuisines.first == "Deli Food" || cuisines.first == "Diner" || cuisines.first == "Wraps")
      return Icon(MyFlutterApp.sandwich, size: 50, color: Colors.grey);
    else if (cuisines.first == "Pizza")
      return Icon(MyFlutterApp.pizza_slice, size: 50, color: Colors.grey);
    else if (cuisines.first == "Italian")
      return Icon(MyFlutterApp.spaghetti, size: 50, color: Colors.grey);
    else if (cuisines.first == "Chinese" || cuisines.first == "Japanese" || cuisines.first == "Asian")
      return Icon(MyFlutterApp.chinese_food, size: 50, color: Colors.grey);
    else if (cuisines.first == "Coffee &amp; Tea")
      return Icon(MyFlutterApp.coffee_cup, size: 50, color: Colors.grey);
    else if (cuisines.first == "Mexican")
      return Icon(MyFlutterApp.taco, size: 50, color: Colors.grey);
    else if (cuisines.first == "Salads" || cuisines.first == "Vegetarian")
      return Icon(MyFlutterApp.salad, size: 50, color: Colors.grey);
    else if (cuisines.first == "Bakery &amp; Pastries" || cuisines.first == "Bagel")
      return Icon(MyFlutterApp.croissant, size: 50, color: Colors.grey);
    else if (cuisines.first == "Sushi")
      return Icon(MyFlutterApp.nigiri, size: 50, color: Colors.grey);
    else if (cuisines.first == "Seafood")
      return Icon(MyFlutterApp.seafood, size: 50, color: Colors.grey);
    else if (cuisines.first == "Chicken")
      return Icon(MyFlutterApp.chicken_leg, size: 50, color: Colors.grey);
    else
      return Icon(MyFlutterApp.cutlery, size: 50, color: Colors.grey);
  }
}