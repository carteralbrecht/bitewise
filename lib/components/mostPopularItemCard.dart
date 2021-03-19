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

class MostPopularItemCard extends StatefulWidget {

  final MenuItem menuItem;
  final Restaurant restaurant;
  final num avgRating;

  const MostPopularItemCard(this.menuItem, this.restaurant, this.avgRating);

  @override
  _MostPopularItemCardState createState() => _MostPopularItemCardState();
}

class _MostPopularItemCardState extends State<MostPopularItemCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantPage(widget.restaurant)));
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text(
                widget.menuItem.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.star, color: global.mainColor, size: 25),
                        SizedBox(width:5),
                        Text(widget.avgRating.toStringAsFixed(1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,)),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.restaurant.name,
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: global.accentGrayDark,),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ]
              ),
            ]
          ),
        ),
      ),
    );
  }
}