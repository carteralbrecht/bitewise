import 'package:flutter/material.dart';

class RatingModal extends StatefulWidget {

  final String dishName;
  final String restaurantName;
  const RatingModal(this.dishName, this.restaurantName);

  @override
  _RatingModalState createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
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
            Text("Rating Widget"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget> [
                TextButton(
                  onPressed: () {

                  },
                  child: Text("cancel"),
                ),
                TextButton(
                  onPressed: () {

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