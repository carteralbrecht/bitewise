import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/pages/restaurantPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitewise/components/ratingModal.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/pages/ratingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitewise/global.dart' as global;

class MenuItemSearchTile extends StatefulWidget {
  final MenuItem menuItem;
  final dynamic restaurant;
  final Future avgRating;
  final Future milesAway;
  final String id;

  const MenuItemSearchTile(this.menuItem, this.restaurant, this.avgRating, this.milesAway, this.id);

  @override
  _MenuItemSearchTileState createState() => _MenuItemSearchTileState();
}

class _MenuItemSearchTileState extends State<MenuItemSearchTile> {

  var avgRating;
  var milesAway;
  Restaurant restaurant;

  @override 
  void initState() {
    getRestaurant();
    super.initState();
  }

  void getRestaurant() async {
    Restaurant r = await widget.restaurant;
    var avg = await widget.avgRating;
    var mi = await widget.milesAway;
    setState(() {
      restaurant = r;
      avgRating = avg;
      milesAway = mi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom:5, top:10),
      height: 100,
      child: Column(
        children: <Widget> [
          Row(
            children: [
              Expanded(
                child: Text(widget.menuItem.name, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))
              ),
              Container(
                child: Row(
                  children: [
                    Icon(Icons.star, color: global.mainColor, size: 25),
                    SizedBox(width:5),
                    Text(avgRating == null ? "0" : avgRating.toStringAsFixed(1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,)),
                  ],
                ),
              ),
            ]
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  restaurant == null ? " " : restaurant.name,
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: global.accentGrayDark,),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                child: milesAway == null ? null : Text(milesAway.toStringAsFixed(2) + " mi", style: TextStyle(fontSize: 15))
              ),
            ]
          )
        ]
      )
    );
  }
}

class SearchTileAndData implements Comparable<dynamic> {
  MenuItemSearchTile m;
  var dist;
  var avg;

  SearchTileAndData(MenuItemSearchTile tile, var distance, var rating) {
    m = tile;
    dist = distance;
    avg = rating;
  }

  Future<dynamic> setVariables() async {
    dist = await dist;
    avg = await avg;
    if (avg == null) avg = 0;
  }

  @override
  int compareTo(dynamic other) {
    int distComp = this.dist.compareTo(other.dist);
    if (distComp == 0) {
      return other.avg.compareTo(this.avg);
    }
    return distComp;
  }
}