import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bitewise/global.dart' as global;
import 'package:bitewise/models/menuItem.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/models/restaurant.dart';

class RatingPage extends StatefulWidget {

  final MenuItem menuItem;
  final Restaurant restaurant;
  const RatingPage(this.menuItem, this.restaurant);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double ratingValue = 0;

  void initState() {
    super.initState();
  }

  Widget _body() {
    return Container (
        margin: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.menuItem.name, style: TextStyle(color: Colors.black, fontSize: 20)),
              SizedBox(height: 5),
              Text(widget.menuItem.description, style: TextStyle(color: Colors.black, fontSize: 14)),
              Padding (
                padding: EdgeInsets.all(5.0),
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
            ]
        )
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // title: Text('bitewise',
        //   style: TextStyle(color: Colors.black, fontSize: 25)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Container(
              height: 35,
              width: 35,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  if (global.user == null) {
                    Navigator.pushNamed(context, '/signin');
                  } else {
                    Navigator.pushNamed(context, '/profile');
                  }
                },
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              )),
        ],
        centerTitle: true,
      ),
      body: _body(),
    );
  }
}