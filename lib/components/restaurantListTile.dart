import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitewise/icons/my_flutter_app_icons.dart';
import 'package:bitewise/util/restaurantUtil.dart';
import 'package:bitewise/global.dart' as global;

class RestaurantListTile extends StatefulWidget {

  final Restaurant restaurant;
  final double milesAway;
  const RestaurantListTile(this.restaurant, this.milesAway);

  @override
  _RestaurantListTileState createState() => _RestaurantListTileState();
}

class _RestaurantListTileState extends State<RestaurantListTile> {

  Icon cuisineIcon;

  @override
  void initState() {
    super.initState();
    cuisineIcon = RestaurantUtil.assignIcon(widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
                // color: global.mainColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: EdgeInsets.only(bottom:5, top:10),
      height: 90,
      child: Card(
        elevation: 0,
        child: ListTile(
          // contentPadding: EdgeInsets.only(left:20, right: 20, top: 10),
          // tileColor: global.mainColor,
          trailing: Container(
            margin: EdgeInsets.only(left: 20),
            child: cuisineIcon,
          ),
          title: Text(widget.restaurant.name, style: TextStyle(color: Colors.black, fontSize:25, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          subtitle: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: Text(
              widget.restaurant.address + " • " + widget.milesAway.toStringAsFixed(2) + " mi", style: TextStyle(fontSize:15)
            ),
          ),
          isThreeLine: true,
        ),
      )
    );
  }
}