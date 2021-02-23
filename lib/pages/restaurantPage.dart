import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:bitewise/util/menuUtil.dart';
import 'package:flutter/material.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/pages/profilePage.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/components/menuItemListTile.dart';
import 'package:bitewise/global.dart' as global;
import 'package:flutter/gestures.dart';


class RestaurantPage extends StatefulWidget {

  final Restaurant restaurant;
  const RestaurantPage(this.restaurant);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  List<MenuItem> menuItems = new List<MenuItem>();
  ButtonStyle rateButton = new ButtonStyle();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    getMenuItems();
    super.initState();
  }

  void getMenuItems() async {
      List<MenuItem> menuItemsTemp = new List<MenuItem>();
      var menu = await MenuUtil.buildMenuForRestaurant(widget.restaurant);
      var allItems = menu.getAllItems();
      for (MenuItem menuItem in allItems)
        menuItemsTemp.add(menuItem);

      setState(() {
        menuItems = menuItemsTemp;
      });
  }

  // Color c1 = const Color(0xE4ECEE);
  Widget restInfo() {
    return Container (
        margin: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: 85,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.restaurant.name, style: TextStyle(color: Colors.black, fontSize: 20)),
              Padding (
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.yellow[600],
                    textColor: Colors.black,
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "Sort",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  FlatButton(
                    color: Colors.yellow[600],
                    textColor: Colors.black,
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "Filter",
                    ),
                  )
                ],
              )
            ]
        )
    );
  }

  Widget _dishList() {
    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: new ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            return new MenuItemListTile(menuItems[i], widget.restaurant);
        })
      )
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        restInfo(),
        menuItems.isEmpty? Text('loading') : _dishList()
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // title: Text('bitewise',
        //   style: TextStyle(color: Colors.black, fontSize: 25)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
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
                  color: Colors.grey,
                ),
              )),
        ],
        centerTitle: true,
      ),
      body: _body(),
    );
  }
}
