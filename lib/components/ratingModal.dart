import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/global.dart' as global;
import 'package:bitewise/pages/signInPage.dart';
import 'package:flushbar/flushbar.dart';

class RatingModal extends StatefulWidget {
  // final String dishName;
  final Restaurant restaurant;
  final MenuItem menuItem;
  final num avgRating;
  const RatingModal(this.menuItem, this.restaurant, this.avgRating);

  @override
  _RatingModalState createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  double ratingValue = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 10),
      elevation: 20,
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.menuItem.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    SizedBox(height: 10),
                  ],
                )
            ),
            Container(
              child:
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child:
                      Text(
                        widget.menuItem.description,
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.star_rate_rounded, size: 50, color: const Color(0xFFFBD96C)),
                    SizedBox(height: 5),
                    Text(
                      widget.avgRating.toStringAsFixed(1).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ]
              ),
            ),
            Container(
                child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Rate this item:",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ],
                )
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child:
              RatingBar(
                initialRating: global.user == null ? 0 : widget.avgRating.toDouble(),
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star_rate_rounded, color: global.mainColor),
                  half: null,
                  empty: Icon(Icons.star_rate_rounded, color: Colors.black26),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                itemSize: 50,
                onRatingUpdate: (rating) {
                  ratingValue = rating;
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    )),
              ),
              FlatButton(
                onPressed: () {
                  if (global.user == null)
                  {
                    Navigator.push(
                      context,
                        MaterialPageRoute(
                          builder: (context) => SignIn()));
                  }
                  else
                  {
                    FirestoreManager().leaveRating(
                        widget.restaurant.id, widget.menuItem.id, ratingValue);
                    Navigator.pop(context);
                    Flushbar(
                      message:  "Successfully left rating!",
                      duration:  Duration(seconds: 3),
                    )..show(context);
                  }
                },
                color: global.mainColor,
                child: Text(global.user == null ? "sign in" : "submit",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ]),
          ]),
    );
  }
}