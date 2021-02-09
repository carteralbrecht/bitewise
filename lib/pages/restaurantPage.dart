import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:bitewise/services/menuUtil.dart';
import 'package:flutter/material.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/pages/profilePage.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/components/menuItemListTile.dart';
import 'package:bitewise/global.dart' as global;
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:flutter/gestures.dart';


class RestaurantPage extends StatefulWidget {

  final Restaurant restaurant;
  const RestaurantPage(this.restaurant);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  List<MenuItem> menuItems = new List<MenuItem>();
  final IndexedScrollController menuController = IndexedScrollController();
  final IndexedScrollController sectionController = IndexedScrollController();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    getMenuItems();
    super.initState();
  }

  void getMenuItems() async {
      List<MenuItem> menuItemsTemp = new List<MenuItem>();
      var menu = await buildMenuForRestaurant(widget.restaurant);
      var allItems = menu.getAllItems();
      for (MenuItem menuItem in allItems)
        menuItemsTemp.add(menuItem);

      setState(() {
        menuItems = menuItemsTemp;
      });
  }


  Widget _dishList() {
    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: new ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            return new MenuItemListTile(menuItems[i], widget.restaurant.name);
        })
      )
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        menuItems.isEmpty? Text('loading') : _dishList()
      ]
    );
  }

  CustomScrollView menu() {


    return CustomScrollView(

    );
  }

  @override
  Widget build(BuildContext context) {
    return new CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 150.0,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Available seats'),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: 'Add new entry',
              onPressed: () { /* ... */ },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: 'Add new entry',
              onPressed: () { /* ... */ },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: 'Add new entry',
              onPressed: () { /* ... */ },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: 'Add new entry',
              onPressed: () { /* ... */ },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: 'Add new entry',
              onPressed: () { /* ... */ },
            ),
          ]
        ),
        SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('List Item $index'),
              );
            },
          ),
        ),
      ]
    );
  }
}
