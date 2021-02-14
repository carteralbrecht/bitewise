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
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/gestures.dart';

class SubSectionHeader extends StatefulWidget {

  final String subsection;
  final int index;

  int get keyIndex {
    return this.index;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        widget.subsection,
        style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: 56.0,
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.white,
        elevation: 5.0,
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class menuSubSectionScrollbar extends StatefulWidget {

  List<String> subsections;
  ScrollController _controller;

  menuSubSectionScrollbar(this.subsections, this._controller);

  @override
  _menuSubSectionScrollbarState createState() => _menuSubSectionScrollbarState();
}

class _menuSubSectionScrollbarState extends State<menuSubSectionScrollbar> {

  int selectedIndex;

  void updateSelectedIndex(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 50,
      child: ListView.builder(
        controller: widget._controller,
        scrollDirection: Axis.horizontal,
        itemCount: widget.subsections.length,
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
                child: Text(widget.subsections[index], style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))
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
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Text(widget.subsections[index], style: TextStyle(color: Colors.black, fontSize: 15))
              )
            );
          }
        },
      )
    );
  }
}


class RestaurantPage extends StatefulWidget {

  final Restaurant restaurant;
  const RestaurantPage(this.restaurant);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  List<MenuItem> menuItems = new List<MenuItem>();
  List<String> subSectionNames = <String>["Section 0","Section 1","Section 2","Section 3","Section 4"];
  List<int> sectionScrollPositions = new List<int>();

  menuSubSectionScrollbar subSectionWidget;
  ScrollController sectionController = new ScrollController();

  Map subSectionToIndexMap = new Map();

  final itemSize = 100.0;
  ScrollController _controller;
  int firstIndex = 0;
  String message = "";

  List<Widget> subSectionsWidgetList;


  _moveUp() {
     //Add logic here
  }

  _moveDown() {
   //Add logic here
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
    else {
      setState(() {
        firstIndex = _controller.position.extentBefore ~/ itemSize;
      });
      print(firstIndex.toString());
      // _controller.animateTo(offset, duration: null, curve: null)
    }
  }


  List<Widget> _menu;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    getMenuItems();
    super.initState();
  }

  void getMenuItems() async {
      List<MenuItem> menuItemsTemp = new List<MenuItem>();
      var menu = await buildMenuForRestaurant(widget.restaurant);
      var allItems = menu.getAllItems();
      // List<String> subsections = menu.getSubsectionNames();

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
        // subSectionNames = subsections;
      });
  }




  List<Widget> generateMenu() {

    List listylist = List<Widget>();
    List<int> positions = new List<int>();
    List<String> subsections = new List<String>();
    List<Widget> subSectionWidgetListTemp = new List<Widget>();

    String subsection = menuItems.elementAt(0).subsection;
    listylist.add(new SubSectionHeader(subsection, 0));
    positions.add(listylist.length - 1);
    subsections.add(subsection);
    subSectionToIndexMap.putIfAbsent(subsection, () => 0);

    int sectionNum = 0;



    for (MenuItem i in menuItems) {
      if (i.subsection != subsection) {
        subsection = i.subsection;
        sectionNum++;
        listylist.add( new SubSectionHeader(subsection, sectionNum));
        positions.add(listylist.length - 1);
        subsections.add(subsection);
        subSectionToIndexMap.putIfAbsent(subsection, () => sectionNum);
        
      }
      listylist.add(new MenuItemListTile(i, widget.restaurant.name));
    }


    setState(() {
      sectionScrollPositions = positions;
      subSectionNames = subsections;
      subSectionWidget = new menuSubSectionScrollbar(subSectionNames, sectionController);
      // subSectionsWidgetList = subSectionWidgetListTemp;
    });

    

    return listylist;
  }

  void SelectSubSection(int newIndex) {
    setState(() {
      subSectionsWidgetList[newIndex] = FlatButton(
        color: Colors.black,
        textColor: Colors.white,
        shape: CircleBorder(),
        onPressed: () {
          print(newIndex.toString() + " was pressed");
          SelectSubSection(newIndex);
        },
        child: Text(subSectionNames[newIndex]),
      );
    });
  }

  // Widget subSections() {

  //   List listylist = List<Widget>();

  //   Color c = Colors.white;

  //   for (String s in subSectionNames) {
  //     listylist.add(
  //       FlatButton(
  //         color: c,
  //         onPressed: () {
  //           c = Colors.blue;
  //           print(s + " was pressed!");
  //         }, 
  //         child: Text(s, style: TextStyle(fontSize: 15, color: Colors.black))
  //       )
  //     );
  //   }

  //   return IndexedListView.builder(
  //     // controller: sectionController, 
  //     itemBuilder: (BuildContext context, int index) {
  //       return listylist[index];
  //     },
  //     maxItemCount: listylist.length,
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    
    return Material(
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            title: Text("Restaurant"),
            centerTitle: true,
            backgroundColor: Colors.green,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.red,
                alignment: Alignment.center,
                child: Text("The details..."),
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
    );
  }

  

}
