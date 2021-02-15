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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.menuItem.name, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5),
                  Text(widget.restaurant.name, style: TextStyle(color: Colors.black45, fontSize: 12, fontStyle: FontStyle.italic),),
              ],
              )
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RatingBar(
                initialRating: 3,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(Icons.circle, color: Colors.amber),
                  half: null,
                  empty: Icon(Icons.radio_button_off, color: Colors.amber),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  ratingValue = rating;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget> [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("cancel", style: TextStyle(color: Colors.black54, fontSize: 15, fontStyle: FontStyle.italic, )),
                ),
                FlatButton(
                  onPressed: () {
                    FirestoreManager().leaveRating(widget.menuItem.id, ratingValue);
                    Navigator.pop(context);
                  },
                  color: Colors.yellow[700],
                  child: Text("submit", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ]
            ),
          ]
        ),
      );
  }
}