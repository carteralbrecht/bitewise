import 'package:bitewise/models/menuItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MenuItemListTile extends StatefulWidget {

  final MenuItem menuItem;
  const MenuItemListTile(this.menuItem);

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
      height: 100,
      child: Card(
        elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.only(left:20, right: 20, top: 10),
          tileColor: Colors.white,
          trailing: Container(
            margin: EdgeInsets.only(left: 20),
            child: Icon(Icons.circle, color:Colors.white, size:50),
          ),
          title: Text(widget.menuItem.name, style: TextStyle(color: Colors.black, fontSize:20, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, maxLines: 3
          ),
          subtitle: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: Text(
                widget.menuItem.description, style: TextStyle(fontSize:15), overflow: TextOverflow.ellipsis, maxLines: 3
            ),
          ),
          isThreeLine: true,
        ),
      )
    );
  }
}