import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:bitewise/global.dart' as global;
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/util/itemListUtil.dart';
import 'package:bitewise/components/prevRatedItemTile.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/pages/restaurantPage.dart';


class PrevRatedItemsPage extends StatefulWidget {
  @override
  _PrevRatedItemsPageState createState() => _PrevRatedItemsPageState();
}

class _PrevRatedItemsPageState extends State<PrevRatedItemsPage> {
  Color dividerColor = global.accentGrayLight;
  final FirestoreManager _fsm = FirestoreManager();
  List<MenuItem> prevRatedItems;
  List<Future<Restaurant>> restaurants;
  List<double> ratings;

  @override
  void initState() {
    getPrevRatedItems();
    super.initState();
  }

  void getPrevRatedItems() async {
    List<Future<MenuItem>> menuItems = await ItemListUtil.getPreviouslyRatedItems();
    List<MenuItem> items = new List<MenuItem>();
    List<Future<Restaurant>> rest = new List<Future<Restaurant>>();
    List<double> prevRatings = new List<double>();
    if (menuItems != null) {
      for (Future<MenuItem> futureItem in menuItems) {
        MenuItem item = await futureItem;
        items.add(item);
        Future<Restaurant> r = Documenu.getRestaurant(item.restaurantId);
        rest.add(r);
        var result = await _fsm.getUserRating(global.user.uid, item.id);
        if (result != null) {
          var prevRating = await _fsm.getDocData('ratings', result, 'rating');
          prevRatings.add(prevRating.toDouble());
        }
      }
    }
    
    setState(() {
      prevRatedItems = items;
      restaurants = rest;
      ratings = prevRatings;
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
      ),
      body: Container(
        child: (ratings == null ? Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(global.mainColor),
          )) :
        ListView.builder(
            itemCount: prevRatedItems == null ? 1 : prevRatedItems.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  height: 90,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(32, 22, 20, 0),
                        child: Text((prevRatedItems.length == 0) ? "No rating history" : "Rating History",
                            style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30)
                        ),
                      ),
                      Divider(
                        thickness: 4,
                        color: dividerColor,
                      ),
                    ]),
                );
              }
              return new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantPage(futureRestaurant: restaurants[index - 1], itemId: prevRatedItems[index - 1].id)))
                      },
                      child: PrevRatedItemTile(prevRatedItems[index - 1], ratings[index - 1], futureRestaurant: restaurants[index - 1]),
                  ),
                  Divider(
                    color: global.accentGrayLight,
                    height: 5,
                    thickness: 5,
                  )
                ],
              );
            },
          )),
      ),
    );
  }
}