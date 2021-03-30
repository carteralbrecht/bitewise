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
  final Restaurant restaurant;
  final num avgRating;
  final double milesAway;

  const MenuItemSearchTile(this.menuItem, this.restaurant, this.avgRating, this.milesAway);

  @override
  _MenuItemSearchTileState createState() => _MenuItemSearchTileState();
}

class _MenuItemSearchTileState extends State<MenuItemSearchTile> {
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
                child: widget.avgRating != null ? Row(
                  children: [
                    Icon(Icons.star, color: global.mainColor, size: 25),
                    SizedBox(width:5),
                    Text(widget.avgRating.toStringAsFixed(1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,)),
                  ],
                ) : Container(height:0, width: 0),
              ),
            ]
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.restaurant.name,
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: global.accentGrayDark,),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                child: Text(widget.milesAway.toStringAsFixed(2) + " mi", style: TextStyle(fontSize: 15))
              ),
            ]
          )
        ]
      )
    );
  }
}