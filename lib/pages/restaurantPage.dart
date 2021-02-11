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

class RestaurantPage extends StatefulWidget {

  final Restaurant restaurant;
  const RestaurantPage(this.restaurant);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  List<MenuItem> menuItems = new List<MenuItem>();
  List<String> subSectionNames = <String>[
    "Section 1", "Section 2", "Section 3", "Section 4", "Section 5", "Section 6", "Section 7", "Section 8"
  ];


  ItemScrollController menuController = ItemScrollController();
  ItemScrollController sectionController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  double alignment = 0;


  List<Widget> _menu;
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
      // List<String> subsections = menu.getSubsectionNames();

      for (MenuItem menuItem in allItems)
        menuItemsTemp.add(menuItem);

      setState(() {
        menuItems = menuItemsTemp;
        _menu = generateMenu();
        // subSectionNames = subsections;
      });
  }




  List<Widget> generateMenu() {

    List listylist = List<Widget>();

    String subsection = menuItems.elementAt(0).subsection;
    listylist.add(new SubSectionHeader(subsection, 0));

    int sectionNum = 0;

    for (MenuItem i in menuItems) {
      if (i.subsection != subsection) {
        subsection = i.subsection;
        sectionNum++;
        listylist.add( new SubSectionHeader(subsection, sectionNum));
      }
      listylist.add(new MenuItemListTile(i, widget.restaurant.name));
    }

    return listylist;
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
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 200.0,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Restaurant")
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    tooltip: 'Add new entry',
                    onPressed: () { /* ... */ },
                  ),
                  
                ]
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: PersistentHeader(
                  widget: Container(
                    height: 150,
                    child: ScrollablePositionedList.builder(
                      scrollDirection: Axis.horizontal,
                      itemScrollController: sectionController,
                      itemCount: subSectionNames.length,
                      itemBuilder:(BuildContext context, int index) {
                        if (index >= 0 && index < subSectionNames.length) {
                          return FlatButton(
                            onPressed: () {
                              print(subSectionNames[index] + " was pressed!");
                              menuController.scrollTo(index: index, duration: Duration(seconds:2));
                            }, 
                            child: Text(subSectionNames[index], style: TextStyle(fontSize: 15, color: Colors.black))
                          );
                        }
                        return null;
                      }
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: (_menu == null ? Container(height: 0, width: 0) : positionsView)),
            ];
          },
          body: _menu == null ? Text("Loading...") : ScrollablePositionedList.builder(
            itemScrollController: menuController, 
            itemCount: _menu.length,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (BuildContext context, int index) {
              positionsView;
              if (index >= 0 && index < _menu.length)
              {
                return _menu[index];
              }
              return null;
            },
          )
        )
      ),
    );
  }

  Widget get positionsView => ValueListenableBuilder<Iterable<ItemPosition>>(
    valueListenable: itemPositionsListener.itemPositions,
    builder: (context, positions, child) {
      int min;
      if (positions.isNotEmpty) {
        // Determine the first visible item by finding the item with the
        // smallest trailing edge that is greater than 0.  i.e. the first
        // item whose trailing edge in visible in the viewport.
        min = positions
            .where((ItemPosition position) => position.itemTrailingEdge > 0)
            .reduce((ItemPosition min, ItemPosition position) =>
                position.itemTrailingEdge < min.itemTrailingEdge
                    ? position
                    : min)
            .index;
        
      }
      print("Position Update Index: " + min.toString());

      // Use min to scroll to sub section
      updateSubSection(min);

      // return null;
      return Container(width: 0.0, height: 0.0);
    },
    
  );

  void updateSubSection(int index) {

    if (_menu[index] is SubSectionHeader) {
      SubSectionHeader h = _menu[index];
      int scrollTo = h.keyIndex;
      sectionController.scrollTo(
        index: scrollTo,
        duration: Duration(seconds:2)
      );
    }
  }

}
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Container(
//         color: Colors.white,
//         child: IndexedListView.builder(
//           controller: menuController,
//           itemBuilder: (BuildContext context, int index) {
//             if (index == 0) 
//             {
//               return SliverAppBar(
//                 pinned: true,
//                 expandedHeight: 150.0,
//                 flexibleSpace: FlexibleSpaceBar(
//                   title: Text("Restaurant")
//                 ),
//                 actions: <Widget>[
//                   IconButton(
//                     icon: const Icon(Icons.add_circle),
//                     tooltip: 'Add new entry',
//                     onPressed: () { /* ... */ },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.add_circle),
//                     tooltip: 'Add new entry',
//                     onPressed: () { /* ... */ },
//                   ),
                  
//                 ]
//               );
//             }
//             else if (index == 1) 
//             {
//               return SliverPersistentHeader(
//                 pinned: true,
//                 delegate: PersistentHeader(
//                   widget: Container(
//                     height: 150,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       controller: sectionController,
//                       itemCount: subSectionNames.length,
//                       itemBuilder:(BuildContext context, int index) {
//                         return FlatButton(
//                           onPressed: () {
//                             print(subSectionNames[index] + " was pressed!");
//                           }, 
//                           child: Text(subSectionNames[index], style: TextStyle(fontSize: 15, color: Colors.black))
//                         );
//                       }
//                     ),
//                   ),
//                 ),
//               );
//             }
//             else 
//             {
//               return _menu == null ? Text("Loading") : _menu[index-2];
//             }
//           },
//         )
            
            
//             // SliverToBoxAdapter(
//             //   child: Container(
//             //     height: 150,
//             //     child: ListView(
//             //       scrollDirection: Axis.horizontal,
//             //       controller: sectionController,
//             //       children: <Widget>[
//             //         Container(
//             //           width: 150,
//             //           alignment: Alignment.center,
//             //           child: Text("Section 1", style: TextStyle(fontSize: 20)),
//             //         ),
//             //         Container(
//             //           width: 150,
//             //           alignment: Alignment.center,
//             //           child: Text("Section 2", style: TextStyle(fontSize: 20)),
//             //         ),
//             //         Container(
//             //           width: 150,
//             //           alignment: Alignment.center,
//             //           child: Text("Section 3", style: TextStyle(fontSize: 20)),
//             //         ),
//             //         Container(
//             //           width: 150,
//             //           alignment: Alignment.center,
//             //           child: Text("Section 4", style: TextStyle(fontSize: 20)),
//             //         ),
//             //         Container(
//             //           width: 150,
//             //           alignment: Alignment.center,
//             //           child: Text("Section 5", style: TextStyle(fontSize: 20)),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             // SliverFixedExtentList(
//             //   itemExtent: 50.0,
//             //   delegate: SliverChildBuilderDelegate(
//             //     (BuildContext context, int index) {
//             //       return Container(
//             //         alignment: Alignment.center,
//             //         color: Colors.lightBlue[100 * (index % 9)],
//             //         child: Text('List Item $index'),
//             //       );
//             //     },
//             //   ),
//             // ),
//         )
//       );
//   }
// }
