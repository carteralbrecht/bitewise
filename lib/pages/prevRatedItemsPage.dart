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

  int selectedSortIndex = 0;
  List<String> sortingTitles = ["Newest to Oldest", "Oldest to Newest", "Lowest to Highest", "Highest to Lowest"];
  List<Widget> sortingTiles;

  @override
  void initState() {
    sortingTiles = getSortingTiles();
    getPrevRatedItems();
    super.initState();
  }

  List<Widget> getSortingTiles() {
    List<Widget> tiles = [
      GestureDetector(
        onTap: () {
          selectedSortIndex = 0;
          newestFirst();
        },
        child: Container(
          color: selectedSortIndex == 0 ? Colors.blue[100] : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sortingTitles[0], style: TextStyle(fontSize: 18, fontWeight: (selectedSortIndex == 0 ?  FontWeight.bold : FontWeight.normal))),
              selectedSortIndex == 0 ? Icon(Icons.check) : Container(height: 0, width: 0),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          selectedSortIndex = 1;
          oldestFirst();
        },
        child: Container(
          color: selectedSortIndex == 1 ? Colors.blue[100] : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sortingTitles[1], style: TextStyle(fontSize: 18, fontWeight: (selectedSortIndex == 1 ?  FontWeight.bold : FontWeight.normal))),
              selectedSortIndex == 1 ? Icon(Icons.check) : Container(height: 0, width: 0),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          selectedSortIndex = 2;
          loToHi();
        },
        child: Container(
          color: selectedSortIndex == 2 ? Colors.blue[100] : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sortingTitles[2], style: TextStyle(fontSize: 18, fontWeight: (selectedSortIndex == 2 ?  FontWeight.bold : FontWeight.normal))),
              selectedSortIndex == 2 ? Icon(Icons.check) : Container(height: 0, width: 0),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          selectedSortIndex = 3;
          hiToLo();
        },
        child: Container(
          color: selectedSortIndex == 3 ? Colors.blue[100] : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sortingTitles[3], style: TextStyle(fontSize: 18, fontWeight: (selectedSortIndex == 3 ?  FontWeight.bold : FontWeight.normal))),
              selectedSortIndex == 3 ? Icon(Icons.check) : Container(height: 0, width: 0),
            ],
          ),
        ),
      ),
    ];

    return tiles;
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

    newestFirst();
  }

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
          child: Column(
            children: [
              
              // Row(
              //   children: <Widget>[
              //     RaisedButton(
              //       onPressed: () => newestFirst(),
              //       child: Text("Newest"),
              //     ),
              //     RaisedButton(
              //       onPressed: () => oldestFirst(),
              //       child: Text("Oldest"),
              //     ),
              //     RaisedButton(
              //       onPressed: () => loToHi(),
              //       child: Text("Lowest"),
              //     ),
              //     RaisedButton(
              //       onPressed: () => hiToLo(),
              //       child: Text("Highest"),
              //     ),
              //   ],
              // ),
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
                            displayItems.length + 1,
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
                          else if (index == 0) {
                            return Column(
                              children: [
                                ExpansionTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Sort By:"),
                                      Text(sortingTitles[selectedSortIndex]),
                                    ]
                                  ),
                                  children: getSortingTiles(),
                                ),
                                Divider(
                                  color: global.accentGrayLight,
                                  height: 5,
                                  thickness: 5,
                                )
                              ],
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
                                                  displayRestaurants[index-1],
                                              itemId: displayItems[index-1].id)))
                                },
                                child: PrevRatedItemTile(
                                    displayItems[index-1], displayRatings[index-1],
                                    futureRestaurant: displayRestaurants[index-1]),
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
            ]
          )
        )
    );
  }
}

class Triple {
  MenuItem item;
  Future<Restaurant> rest;
  double rate;
  Triple(this.item, this.rest, this.rate);
}
