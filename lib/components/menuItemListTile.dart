import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitewise/components/ratingModal.dart';

class MenuItemListTile extends StatefulWidget {

  final MenuItem menuItem;
  final Restaurant restaurant;
  const MenuItemListTile(this.menuItem, this.restaurant);

  @override
  _MenuItemListTile createState() => _MenuItemListTile();
}

class _MenuItemListTile extends State<MenuItemListTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                // borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: EdgeInsets.only(left:10,right:10, bottom:10, top:10),
      height: 120,
      child: Card(
        elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.only(left:20, right: 20, top: 10),
          tileColor: Colors.white,
          trailing: Column(
            children: <Widget> [
              FlatButton(
                onPressed: () {
                  showDialog(
                                context: context,
                                builder: (_) => RatingModal(widget.menuItem, widget.restaurant),
                                barrierDismissible: true);
                },
                child: Text("rate"),
                color: Colors.yellow[700],
              ),
            ]
          ),
          title: Text(widget.menuItem.name, style: TextStyle(color: Colors.black, fontSize:20, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, maxLines: 1
          ),
          subtitle: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: Text(
                widget.menuItem.description, style: TextStyle(fontSize:15), overflow: TextOverflow.ellipsis, maxLines: 3
            ),
          ),
          isThreeLine: false,
        ),
      )
    );
  }
}