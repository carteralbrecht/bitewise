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
import 'package:flutter/gestures.dart';
import 'package:bitewise/pages/ratingPage.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class SubSectionHeader extends StatefulWidget {

  final String subsection;
  final int index;
  final double height;

  int get keyIndex {
    return this.index;
  }

  String get subSectionName {
    return this.subsection;
  }

  SubSectionHeader(this.subsection, this.index, this.height);

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
    return Container(
      height: widget.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 5),
            child: Text(
              widget.subsection,
              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold,),
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(color: dividerColor, thickness: 5, indent: 20, endIndent: 20,),
        ],
      )
    );
  }
}


class MenuSubSectionScrollbar extends StatefulWidget {

  final Key _key;
  final List<SubSection> subsections;
  final ItemScrollController _sectionController;
  final ScrollController _menuController;
  final double menuItemHeight;
  final double menuSSHeight;

  MenuSubSectionScrollbar(this._key, this.subsections, this._sectionController, this._menuController, this.menuItemHeight, this.menuSSHeight) : super(key: _key);

  @override
  _MenuSubSectionScrollbarState createState() => _MenuSubSectionScrollbarState();
}

class _MenuSubSectionScrollbarState extends State<MenuSubSectionScrollbar> {

  Stopwatch scrollStart = new Stopwatch();
  int selectedIndex;

  double menuItemHeight;
  double menuSubsectionHeight;

  List<GlobalKey> keyList = new List<GlobalKey>();

  Map<int, double> indexToOffsetMap = new Map();

  // double itemWidth = 125;

  void tryUpdateSubSection(String s) {
    int newIndex = 0;

    if (widget == null) {
      print("Widget is null");
      return;
    }
    
    if (scrollStart.elapsedMilliseconds < 750 && scrollStart.elapsedMilliseconds != 0) {
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

      widget._sectionController.scrollTo(index: newIndex, duration: Duration(milliseconds: 500), curve: Curves.linear);
      scrollStart.start();
      setState(() {
        selectedIndex = newIndex;
      });
      return;
    }
  
  }

  void updateSelectedIndex(int newIndex) {
    scrollStart.stop();
    scrollStart.reset();
    scrollStart.start();
    setState(() {
      selectedIndex = newIndex;
      widget._sectionController.scrollTo(index: newIndex, duration: Duration(milliseconds: 500), curve: Curves.linear);
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
    menuItemHeight = widget.menuItemHeight;
    menuSubsectionHeight = widget.menuSSHeight;
    selectedIndex = 0;
    scrollStart.start();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 50,
      child: ScrollablePositionedList.builder(
        itemScrollController: widget._sectionController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.subsections.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == selectedIndex) {
            return Container(
              // width: itemWidth,
              decoration: new BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: FlatButton(
                onPressed: () {
                  print("Selected Index : " + index.toString() + " was pressed");
                },
                child: Text(widget.subsections[index].name, style: TextStyle(color: Colors.white, fontSize: 15))
              )
            );
          }
          else {
            return Container(
              // width: itemWidth,
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: FlatButton(
                color: Colors.transparent,
                onPressed: () {
                  print("Unselected index : " + index.toString() + " was pressed");
                  updateSelectedIndex(index);
                },
                child: Text(widget.subsections[index].name, style: TextStyle(color: Colors.black, fontSize: 15)),
              )
            );
          }
        },
      ),
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
  // ScrollController sectionController = new ScrollController();
  final ItemScrollController sectionController = ItemScrollController();


  final double itemHeight = 125.0;
  final double subSectionHeight = 90;
  ScrollController _menuController;
  int firstIndex = 0;
  String message = "";
  int numItemsRated = 0;
  String cuisineString = "";

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
  List<SubSection> sectionList = List<SubSection>();
  final AuthService _auth = AuthService();
  final FirestoreManager _fsm = FirestoreManager();

  @override
  void initState() {
    _menuController = ScrollController();
    _menuController.addListener(_scrollListener);
    restaurantIcon = RestaurantUtil.assignIcon(widget.restaurant);
    getMenuItems();
    getNumItemsRated();
    getCuisineString();
    super.initState();
  }

  void getNumItemsRated() async {
    var ratedList = await _fsm.getDocData(_fsm.restaurantCollection, widget.restaurant.id, "ratedItems");
    int numRated = 0;
    if (ratedList is List) {
      numRated = ratedList.length;
    }

    setState(() {
      numItemsRated = numRated;
    });
  }

  void getCuisineString() {
    String s = "";
      // print(widget.restaurant.cuisines.length.toString());

    for (int i = 0; i < widget.restaurant.cuisines.length && i < 3; i++) {
      s += widget.restaurant.cuisines[i] + ", ";
    }
    setState(() {
      cuisineString = s;
    });
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
    listylist.add(new SubSectionHeader(subsection, sectionNum, subSectionHeight));
   

    for (int i = 0; i < menuItems.length; i++) {
      if (menuItems[i].subsection != subsection) {
        sectionList.add(new SubSection(subsection, i - prevIndex));
        subsection = menuItems[i].subsection;
        prevIndex = i;
        listylist.add( new SubSectionHeader(subsection, sectionNum, subSectionHeight));
      }
      listylist.add(new MenuItemListTile(menuItems[i], widget.restaurant, itemHeight));
    }
    sectionList.add(new SubSection(subsection, menuItems.length - prevIndex));

    setState(() {
      subSectionWidget = new MenuSubSectionScrollbar(_key, sectionList, sectionController, _menuController, itemHeight, subSectionHeight);
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
                              Text(cuisineString, style: TextStyle(fontSize:15)),
                              Text(numItemsRated.toString() + " items rated", style: TextStyle(fontSize:15), textAlign: TextAlign.left),
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
