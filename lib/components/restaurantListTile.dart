import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RestaurantListTile extends StatefulWidget {

  final String name;
  final String address;
  const RestaurantListTile(this.name,this.address);

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
      margin: EdgeInsets.only(left:10,right:10, bottom:10, top:5),
      child: Card(
        elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.only(left:20, right: 20),
          tileColor: Color.fromRGBO(250,202,51,1),
          trailing: Container(
            margin: EdgeInsets.only(left: 20),
            child: Icon(Icons.circle, color:Colors.white, size:50),
          ),
          title: Text(widget.name, style: TextStyle(color: Colors.black, fontSize:25, fontWeight: FontWeight.bold)),
          subtitle: Text(
            widget.address,
          ),
          isThreeLine: true,
        ),
      )
    );
  }
}