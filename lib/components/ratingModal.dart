import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bitewise/services/fsmanager.dart';

class RatingModal extends StatefulWidget {

  final String dishName;
  final String restaurantName;
  const RatingModal(this.dishName, this.restaurantName);

  @override
  _RatingModalState createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  double ratingValue = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 20,
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Dish Name", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                  Text("Restaurant", style: TextStyle(color: Colors.black45, fontSize: 12, fontStyle: FontStyle.italic),),
              ],
              )
            ),
            Container(
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel"),
                ),
                TextButton(
                  onPressed: () {
                    FirestoreManager().leaveRating("somereallygoodmenuitem", ratingValue);
                    Navigator.of(context).pop();
                  },
                  child: Text("submit"),
                ),
              ]
            ),
          ]
        ),
      );
  }
}