import 'dart:ui';
import 'package:bitewise/services/auth.dart';
import 'package:bitewise/services/menuUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/pages/profilePage.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/components/menuItemListTile.dart';
import 'package:bitewise/global.dart' as global;
import 'package:bitewise/services/restaurantUtil.dart';


class SubSectionHeader extends StatefulWidget {

  final String subsection;
  final int index;

  int get keyIndex {
    return this.index;
  }

  String get subSectionName {
    return this.subsection;
  }

  SubSectionHeader(this.subsection, this.index);

  @override
  _SubSectionHeaderState createState() => _SubSectionHeaderState();
}

class _SubSectionHeaderState extends State<SubSectionHeader> {

  @override
  void initState() {
    super.initState();
  }

  Color dividerColor = Color.fromRGBO(228,236,238,1);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          child: Text(
            widget.subsection,
            style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.left,
          ),
        ),
        Divider(color: dividerColor, thickness: 5, indent: 20, endIndent: 20,),
      ],
    );
  }
}


class MenuSubSectionScrollbar extends StatefulWidget {

  final Key _key;
  final List<SubSection> subsections;
  final ScrollController _sectionController;
  final ScrollController _menuController;

  MenuSubSectionScrollbar(this._key, this.subsections, this._sectionController, this._menuController) : super(key: _key);

  @override
  _MenuSubSectionScrollbarState createState() => _MenuSubSectionScrollbarState();
}

class _MenuSubSectionScrollbarState extends State<MenuSubSectionScrollbar> {

  Stopwatch scrollStart = new Stopwatch();
  int selectedIndex;
  double itemWidth = 150;

  void tryUpdateSubSection(String s) {
    int newIndex = 0;

    if (widget == null) {
      print("Widget is null");
      return;
    }
    
    if (scrollStart.elapsedMilliseconds < 500 && scrollStart.elapsedMilliseconds != 0) {
      print("Didn't update because elapsed time = " + scrollStart.elapsedMilliseconds.toString());
      return; 
    }
    else {
      for (int i = 0; i < widget.subsections.length; i++) {
        if (widget.subsections[i].name == s) {
          newIndex = i;
          break;
        }
      }
      scrollStart.stop();
      scrollStart.reset();
      try {
        widget._sectionController.animateTo(newIndex * itemWidth, duration: Duration(milliseconds: 500), curve: Curves.linear);
        scrollStart.start();
        setState(() {
          selectedIndex = newIndex;
        });
      }
      catch(e) {
        print(e.toString());
      }
      return;
    }
  
  }

  double menuItemHeight = 100;
  double menuSubsectionHeight = 100;

  void updateSelectedIndex(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
      widget._sectionController.animateTo(newIndex * itemWidth, duration: Duration(milliseconds: 500), curve: Curves.linear);
      scrollMenu();
    });
  }

  void scrollMenu() {
    double scrollDistance = 0;
    if (selectedIndex == 0) {
      scrollDistance += menuSubsectionHeight;
    }
    for (int i = 0 ; i < selectedIndex; i++) {
      scrollDistance += menuSubsectionHeight;
      scrollDistance += widget.subsections[i].numItems * menuItemHeight;
    }
    widget._menuController.animateTo(scrollDistance, duration: Duration(milliseconds: 500), curve: Curves.linear);
    setState(() {
      scrollStart.start();
    });
  }

  

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    scrollStart.start();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 50,
      child: ListView.builder(
        controller: widget._sectionController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.subsections.length,
        itemExtent: itemWidth,
        itemBuilder: (BuildContext context, int index) {
          if (index == selectedIndex) {
            return Container(
              decoration: new BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: FlatButton(
                onPressed: () {
                  print("Selected Index : " + index.toString() + " was pressed");
                },
                child: Text(widget.subsections[index].name, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))
              )
            );
          }
          else {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: FlatButton(
                color: Colors.transparent,
                onPressed: () {
                  print("Unselected index : " + index.toString() + " was pressed");
                  updateSelectedIndex(index);
                },
                child: Text(widget.subsections[index].name, style: TextStyle(color: Colors.black, fontSize: 15))
              )
            );
          }
        },
      )
    );
  }
}

class SubSection {

  String name;
  int numItems;

  // Costructor
  SubSection(String s, int n) {
    name = s;
    numItems = n;
  }

  String get section_name {
    return name;
  }

  int get num_items {
    return numItems;
  }
}


class RestaurantPage extends StatefulWidget {

  final Restaurant restaurant;
  const RestaurantPage(this.restaurant);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  final GlobalKey<_MenuSubSectionScrollbarState> _key = GlobalKey();

  List<MenuItem> menuItems = new List<MenuItem>();

  MenuSubSectionScrollbar subSectionWidget;
  ScrollController sectionController = new ScrollController();


  final double itemHeight = 100.0;
  ScrollController _menuController;
  int firstIndex = 0;
  String message = "";

  String currentSubSection = "";

  Icon restaurantIcon;


  _scrollListener() {
    if (_menuController.offset >= _menuController.position.maxScrollExtent &&
        !_menuController.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
      });
    }
    if (_menuController.offset <= _menuController.position.minScrollExtent &&
        !_menuController.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
    else {
      setState(() {
        firstIndex = _menuController.position.extentBefore ~/ itemHeight;
        
      });
      if (_menu[firstIndex] is SubSectionHeader) {
        SubSectionHeader h = _menu[firstIndex];
        if (_key.currentState != null) {
          _key.currentState.tryUpdateSubSection(h.subsection);
          print("Trying to scroll the header!");
        }
        else {
          print("Current key state = null :(");
        }
      } 
      print(firstIndex.toString());
    }
  }


  List<Widget> _menu;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    _menuController = ScrollController();
    _menuController.addListener(_scrollListener);
    restaurantIcon = RestaurantUtil.assignIcon(widget.restaurant);
    getMenuItems();
    super.initState();
  }

  void getMenuItems() async {
      List<MenuItem> menuItemsTemp = new List<MenuItem>();
      var menu = await buildMenuForRestaurant(widget.restaurant);
      var allItems = menu.getAllItems();

      for (MenuItem menuItem in allItems)
        menuItemsTemp.add(menuItem);

      if (menuItemsTemp.length == 0) {
        print("No menu items");
        // TODO: Handle error
        return; 
      }

      setState(() {
        menuItems = menuItemsTemp;
        _menu = generateMenu();
      });
  }




  List<Widget> generateMenu() {

    List listylist = List<Widget>();

    List<SubSection> sectionList = List<SubSection>();

    int sectionNum = 0;
    int prevIndex = 0;
    

    String subsection = menuItems.elementAt(sectionNum).subsection;
    listylist.add(new SubSectionHeader(subsection, sectionNum));
   

    for (int i = 0; i < menuItems.length; i++) {
      if (menuItems[i].subsection != subsection) {
        sectionList.add(new SubSection(subsection, i - prevIndex));
        subsection = menuItems[i].subsection;
        prevIndex = i;
        listylist.add( new SubSectionHeader(subsection, sectionNum));
      }
      listylist.add(new MenuItemListTile(menuItems[i], widget.restaurant.name, itemHeight));
    }
    sectionList.add(new SubSection(subsection, menuItems.length - prevIndex));

    setState(() {
      subSectionWidget = new MenuSubSectionScrollbar(_key, sectionList, sectionController, _menuController);
      // sectionScrollState = subSectionWidget.createState();
    });


    return listylist;
  }


  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Material(
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            controller: _menuController,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                title: Text(widget.restaurant.name, style: TextStyle(fontSize: 25, color: Colors.black)),
                centerTitle: true,
                backgroundColor: Color.fromRGBO(250,202,51,1),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Color.fromRGBO(250,202,51,0.72),
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 25),
                              Text("American, Pizza, Italian", style: TextStyle(fontSize:15)),
                              Text("7 items rated", style: TextStyle(fontSize:15), textAlign: TextAlign.left),
                              Container(
                                width: 100,
                                alignment: Alignment.centerLeft,
                                child: Text(widget.restaurant.address, style: TextStyle(fontSize:15)),
                              ),
                              Text("Hours: 1:00 - 10:00", style: TextStyle(fontSize:15), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          alignment: Alignment.center,
                          child: restaurantIcon,
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: firstIndex == 0 ? Size(0,0) : Size.fromHeight(50),
                  child: firstIndex == 0 ? Container(height:0, width: 0) : (subSectionWidget == null ? Text("Loading") : subSectionWidget),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  _menu == null ? [Text("Loading")] : _menu,
                ),
              ),
              
            ]
          ),
        ),
      )
    );
  }

  

}
