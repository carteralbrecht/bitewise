import 'package:bitewise/models/menuItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitewise/components/ratingModal.dart';

class MenuItemListTile extends StatefulWidget {

  final MenuItem menuItem;
  final String restaurantName;
  final double height;
  const MenuItemListTile(this.menuItem, this.restaurantName, this.height);

  @override
  _MenuItemListTile createState() => _MenuItemListTile();
}

class _MenuItemListTile extends State<MenuItemListTile> {

  Color dividerColor = Color.fromRGBO(228,236,238,1);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                // border: Border(bottom: BorderSide(width: 3, color: Colors.grey)),
                // borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: EdgeInsets.only(left:10,right:10, ),
      height: widget.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 0,
            child: ListTile(
              // contentPadding: EdgeInsets.only(left:20, right: 20, top: 10),
              tileColor: Colors.white,
              trailing: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.yellow[700],size: 40,),
                    SizedBox(width:10),
                    Text("4.0", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                )
              ),
              title: Text(widget.menuItem.name, style: TextStyle(color: Colors.black, fontSize:20),
                  overflow: TextOverflow.ellipsis, maxLines: 1
              ),
              subtitle: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                child: Text(
                    widget.menuItem.description, style: TextStyle(fontSize:15), overflow: TextOverflow.ellipsis, maxLines: 2
                ),
              ),
              isThreeLine: false,
            ),
          ),
          Divider(thickness: 4, color: dividerColor, indent: 30, endIndent: 30,),
        ],
      ),
    );
  }
}