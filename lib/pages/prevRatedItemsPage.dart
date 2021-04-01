import 'package:bitewise/models/menu.dart';
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
  List<MenuItem> displayItems;
  List<Future<Restaurant>> displayRestaurants;
  List<double> displayRatings;

  List<MenuItem> prevRatedItems;
  List<Future<Restaurant>> restaurants;
  List<double> ratings;

  List<MenuItem> prevRatedItemsSorted;
  List<Future<Restaurant>> restaurantsSorted;
  List<double> ratingsSorted;

  @override
  void initState() {
    getPrevRatedItems();
    super.initState();
  }

  void getPrevRatedItems() async {
    List<Future<MenuItem>> menuItems =
        await ItemListUtil.getPreviouslyRatedItems();
    List<MenuItem> items = new List<MenuItem>();
    List<Future<Restaurant>> rest = new List<Future<Restaurant>>();
    List<double> prevRatings = new List<double>();
    List<Triple> pairs = new List<Triple>(); //
    if (menuItems != null) {
      for (Future<MenuItem> futureItem in menuItems) {
        MenuItem item = await futureItem;
        if (item == null) {
          continue;
        }
        items.add(item);
        Future<Restaurant> r = Documenu.getRestaurant(item.restaurantId);
        rest.add(r);
        var result = await _fsm.getUserRating(global.user.uid, item.id);
        if (result != null) {
          var prevRating = await _fsm.getDocData('ratings', result, 'rating');
          prevRatings.add(prevRating.toDouble());
          pairs.add(new Triple(item, r, prevRating.toDouble())); //
        }
      }
    }

    pairs.sort((a, b) => (a.rate.compareTo(b.rate)));
    List<MenuItem> sortitem = new List();
    List<Future<Restaurant>> sortrest = new List();
    List<double> sortrate = new List();

    for (Triple t in pairs) 
    {
      sortitem.add(t.item);
      sortrest.add(t.rest);
      sortrate.add(t.rate);
    }

    setState(() {
      prevRatedItems = items;
      restaurants = rest;
      ratings = prevRatings;

      prevRatedItemsSorted = sortitem;
      restaurantsSorted = sortrest;
      ratingsSorted = sortrate;
    });

    oldestFirst();
  }

  // Future sortByRatings() async {
  //   List<MenuItem> menu = new List.from(prevRatedItems);
  //   List<Future<Restaurant>> rest = new List.from(restaurants);
  //   List<double> rate = new List.from(ratings);

  //   // make triple list

  //   // sort triple list

  //   // convert back to three lists
  // }

  // Future sortByRatings() async {
  //   List<MenuItem> menu = new List.from(prevRatedItems);
  //   List<Future<Restaurant>> rest = new List.from(restaurants);
  //   List<double> rate = new List.from(ratings);
  //   bool b;

  //   print(rate.length);
  //   // TODO : Change from bubble sort
  //   for (int i = 0; i < rate.length; i++) {
  //     for (int j = 1; j < rate.length; j++) {
  //       if (rate.elementAt(j - 1) > rate.elementAt(j)) {
  //         int a = j - 1, b = j;
  //         // b = await swap(menu, rest, rate, j - 1, j);
  //         MenuItem tempMenuItem = menu.elementAt(a);
  //         menu.insert(a, menu.elementAt(b));
  //         menu.insert(b, tempMenuItem);
  //         Future<Restaurant> tempRest = rest.elementAt(a);
  //         rest.insert(a, rest.elementAt(b));
  //         rest.insert(b, tempRest);
  //         double tempRate = rate.elementAt(a);
  //         rate.insert(a, rate.elementAt(b));
  //         rate.insert(b, tempRate);
  //         //
  //       }
  //     }
  //     print(i);
  //   }

  //   setState(() {
  //     prevRatedItemsSorted = menu;
  //     restaurantsSorted = rest;
  //     ratingsSorted = rate;
  //   });
  //   return b;
  // }

  // Future swap(List<MenuItem> menu, List<Future<Restaurant>> rest,
  //     List<double> rate, int a, int b) async {
  //   MenuItem tempMenuItem = menu.elementAt(a);
  //   menu.insert(a, menu.elementAt(b));
  //   menu.insert(b, tempMenuItem);
  //   Future<Restaurant> tempRest = rest.elementAt(a);
  //   rest.insert(a, rest.elementAt(b));
  //   rest.insert(b, tempRest);
  //   double tempRate = rate.elementAt(a);
  //   rate.insert(a, rate.elementAt(b));
  //   rate.insert(b, tempRate);
  //   return true;
  // }

  void oldestFirst() async {
    setState(() {
      displayItems = new List.from(prevRatedItems);
      displayRestaurants = new List.from(restaurants);
      displayRatings = new List.from(ratings);
    });
  }

  void newestFirst() async {
    setState(() {
      displayItems = new List.from(prevRatedItems.reversed);
      displayRestaurants = new List.from(restaurants.reversed);
      displayRatings = new List.from(ratings.reversed);
    });
  }

  void loToHi() async {
    setState(() {
      displayItems = new List.from(prevRatedItemsSorted);
      displayRestaurants = new List.from(restaurantsSorted);
      displayRatings = new List.from(ratingsSorted);
    });
  }

  void hiToLo() async {
    setState(() {
      displayItems = new List.from(prevRatedItemsSorted.reversed);
      displayRestaurants = new List.from(restaurantsSorted.reversed);
      displayRatings = new List.from(ratingsSorted.reversed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: global.mainColor,
          elevation: 0,
          leading: GestureDetector(
              child: Icon(Icons.chevron_left, size: 35, color: Colors.black),
              onTap: () {
                Navigator.pop(context);
              }),
          title: Text("Rating History",
              style: TextStyle(fontSize: 25, color: Colors.black)),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Row(children: <Widget>[RaisedButton(
            onPressed: () => newestFirst(),
            child: Text("Newest"),
          ),
          RaisedButton(
            onPressed: () => oldestFirst(),
            child: Text("Oldest"),
          ),
          RaisedButton(
            onPressed: () => loToHi(),
            child: Text("Lowest"),
          ),
          RaisedButton(
            onPressed: () => hiToLo(),
            child: Text("Highest"),
          ),
          ],),
          Container(
            child: (displayRatings == null
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(global.mainColor),
                  ))
                : Expanded(
                    child: ListView.builder(
                    itemCount:
                        displayItems.length == 0 ? 1 : displayItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0 && displayItems.length == 0) {
                        return Container(
                          height: 90,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(32, 22, 20, 0),
                                  child: Text("No rating history",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20)),
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
                                      builder: (context) => RestaurantPage(
                                          futureRestaurant:
                                              displayRestaurants[index],
                                          itemId: displayItems[index].id)))
                            },
                            child: PrevRatedItemTile(
                                displayItems[index], displayRatings[index],
                                futureRestaurant: displayRestaurants[index]),
                          ),
                          Divider(
                            color: global.accentGrayLight,
                            height: 5,
                            thickness: 5,
                          )
                        ],
                      );
                    },
                  ))),
          ),
        ])));
  }
}

class Triple {
  MenuItem item;
  Future<Restaurant> rest;
  double rate;
  Triple(this.item, this.rest, this.rate);
}
