import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitewise/components/ratingModal.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/pages/ratingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitewise/global.dart' as global;

class MenuItemListTile extends StatefulWidget {
  final MenuItem menuItem;
  final Restaurant restaurant;
  final double height;
  const MenuItemListTile(this.menuItem, this.restaurant, this.height);

  @override
  _MenuItemListTile createState() => _MenuItemListTile();
}

class _MenuItemListTile extends State<MenuItemListTile> {
  Color dividerColor = global.accentGrayLight;

  final FirestoreManager _fsm = FirestoreManager();

  String itemId;
  num avgRating = 0;

  void getAvgRating() async {
    var res = await _fsm.getDocData(
        _fsm.menuItemCollection, widget.menuItem.id, "avgRating");
    if (res == null) {
      res = 0;
    }
    if (mounted) setState(() {
      avgRating = res;
    });
  }

  @override
  initState() {
    super.initState();
    getAvgRating();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navigator.push(
          // context,
          // MaterialPageRoute(
          // builder: (context) => RatingPage(widget.menuItem, widget.restaurant)
          // )
          //);
          showDialog(
              context: context,
              builder: (_) =>
                  RatingModal(widget.menuItem, widget.restaurant, avgRating),
              barrierDismissible: true);
        },
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            // border: Border(bottom: BorderSide(width: 3, color: Colors.grey)),
            // borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          margin: EdgeInsets.only(
            left: 0,
            right: 0,
          ),
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
                      Icon(
                        Icons.star,
                        color: global.mainColor,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      StreamBuilder<Object>(
                        stream: (Firestore.instance.collection(_fsm.menuItemCollection).document(widget.menuItem.id).snapshots()),
                        builder:(BuildContext context, AsyncSnapshot snapshot) {
                          String streamAvgRating = "0";
                          try 
                          {
                            streamAvgRating = snapshot.data['avgRating'].toString();
                          } 
                          catch (e) 
                          {
                            streamAvgRating = "0";
                          }
                          return Text(streamAvgRating,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold));
                      }),
                    ],
                  )),
                  title: Text(widget.menuItem.name,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  subtitle: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                    child: Text(widget.menuItem.description,
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                  ),
                  isThreeLine: false,
                ),
              ),
              Divider(
                thickness: 4,
                color: dividerColor,
                indent: 30,
                endIndent: 30,
              ),
            ],
          ),
        ));
  }
}
