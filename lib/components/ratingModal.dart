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
      content: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Dish Name"),
            Text("Restaurant Name"),
            Text("Rating Widget"),
            Text("Submit Button"),
          ]
        ),
      ),
    );
  }
}