import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/models/menuItem.dart';

class RatingModal extends StatefulWidget {
  // final String dishName;
  final Restaurant restaurant;
  final MenuItem menuItem;
  const RatingModal(this.menuItem, this.restaurant);

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
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.menuItem.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  SizedBox(height: 5),
                ],
            )),
            Container(
              child:
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.menuItem.description,
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 12),
                              ),
                            ]
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.star_rate_rounded, size: 35, color: Colors.yellow[700]),
                          ]
                      ),
                      SizedBox(width: 5),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "4.3",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ]
                      ),
                    ]
                ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RatingBar(
                initialRating: 3,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star_rate_rounded, color: Colors.yellow[700]),
                  half: null,
                  empty: Icon(Icons.star_rate_rounded, color: Colors.black26),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
                  FirestoreManager().leaveRating(
                      widget.restaurant.id, widget.menuItem.id, ratingValue);
                  Navigator.pop(context);
                },
                color: Colors.yellow[700],
                child: Text("submit",
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
