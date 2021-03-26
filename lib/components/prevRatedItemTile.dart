import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitewise/components/ratingModal.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/pages/ratingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitewise/global.dart' as global;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class PrevRatedItemTile extends StatefulWidget {
  final MenuItem menuItem;
  final Restaurant restaurant;
  final double rating;
  const PrevRatedItemTile(this.menuItem, this.restaurant, this.rating);

  @override
  _PrevRatedItemTileState createState() => _PrevRatedItemTileState();
}

class _PrevRatedItemTileState extends State<PrevRatedItemTile> {
  Color dividerColor = global.accentGrayLight;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        // border: Border(bottom: BorderSide(width: 3, color: Colors.grey)),
        // borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: EdgeInsets.only(
        left: 0,
        right: 0,
      ),
      height: 155.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 0,
            child: ListTile(
              // contentPadding: EdgeInsets.only(left:20, right: 20, top: 10),
              tileColor: Colors.white,
              title: Text(widget.menuItem.name,
                  style: TextStyle(color: Colors.black, fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
              subtitle: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.restaurant.name,
                    style: TextStyle(color: global.accentGrayDark, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
                    Text(widget.menuItem.description,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
                    RatingBar(
                      initialRating: widget.rating,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      ignoreGestures: false,
                      ratingWidget: RatingWidget(
                        full: Icon(Icons.star_rate_rounded, color: global.mainColor),
                        half: null,
                        empty: Icon(Icons.star_rate_rounded, color: Colors.black26),
                      ),
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemSize: 50,
                      onRatingUpdate: (rating){
                        // Dont do anything
                      },
                    ),
                ]),
              ),
              isThreeLine: false,
            ),
          ),
        ],
      ),
    );
  }
}
