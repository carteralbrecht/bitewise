import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:bitewise/global.dart' as global;
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/util/itemListUtil.dart';
import 'package:bitewise/components/prevRatedItemTile.dart';
import 'package:bitewise/services/documenu.dart';

class PrevRatedItemsPage extends StatefulWidget {
  @override
  _PrevRatedItemsPageState createState() => _PrevRatedItemsPageState();
}

class _PrevRatedItemsPageState extends State<PrevRatedItemsPage> {
  var prevRatedItems;
  var restaurants;

  @override
  void initState() {
    getPrevRatedItems();
    super.initState();
  }

  void getPrevRatedItems() async {
    List<Future<MenuItem>> menuItems = await ItemListUtil.getPreviouslyRatedItems();
    List<MenuItem> items = new List<MenuItem>();
    List<Restaurant> rest = new List<Restaurant>();
    for (Future<MenuItem> futureItem in menuItems) {
      MenuItem item = await futureItem;
      items.add(item);
      Restaurant r = await Documenu.getRestaurant(item.restaurantId);
      rest.add(r);
    }
    setState(() {
      prevRatedItems = items;
      restaurants = rest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: global.mainColor,
        elevation: 0,
        leading: GestureDetector(
            child: Icon(Icons.chevron_left, size: 35, color: Colors.black),
            onTap: () {
              Navigator.pop(context);
            }
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
                  size: 30,
                  color: global.mainColor,
                ),
              )
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: prevRatedItems.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                height: 90,
                child: Text("Rating History",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              );
            }
            return new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    onPressed: () => {
                      // TODO Figure out how to scroll to certain position in the menu.
                    },
                    child: PrevRatedItemTile(prevRatedItems[index - 1], restaurants[index - 1])
                ),
                Divider(
                  color: global.accentGrayLight,
                  height: 5,
                  thickness: 5,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}