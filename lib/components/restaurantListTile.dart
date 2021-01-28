import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RestaurantListTile extends StatefulWidget {

  final Restaurant restaurant;
  final double milesAway;
  const RestaurantListTile(this.restaurant, this.milesAway);

  @override
  _RestaurantListTileState createState() => _RestaurantListTileState();
}

class _RestaurantListTileState extends State<RestaurantListTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
                color: Color.fromRGBO(250,202,51,1),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: EdgeInsets.only(left:10,right:10, bottom:10, top:10),
      height: 100,
      child: Card(
        elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.only(left:20, right: 20, top: 10),
          tileColor: Color.fromRGBO(250,202,51,1),
          trailing: Container(
            margin: EdgeInsets.only(left: 20),
            child: Icon(Icons.circle, color:Colors.white, size:50),
          ),
          title: Text(widget.restaurant.name, style: TextStyle(color: Colors.black, fontSize:25, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          subtitle: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: Text(
              widget.milesAway.toStringAsFixed(2) + " Miles", style: TextStyle(fontSize:20)
            ),
          ),
          isThreeLine: true,
        ),
      )
    );
  }
}