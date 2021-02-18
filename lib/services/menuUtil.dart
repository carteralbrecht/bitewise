import 'dart:collection';

import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/services/fsmanager.dart';

class Menu {
  // Keep the subsections in order they were given from documenu
  // subsection name to list of menu items
  final LinkedHashMap<String, List<MenuItem>> subsectionMap;

  static const POPULAR_ITEMS_SUBSECTION_NAME = "Most Popular";
  final instanceMostPopName = POPULAR_ITEMS_SUBSECTION_NAME;

  Menu._(this.subsectionMap);

  factory Menu(subsectionNames) {
    if (subsectionNames == null) {
      return null;
    }
    Map<String, List<MenuItem>> map = new Map<String, List<MenuItem>>();
    map[POPULAR_ITEMS_SUBSECTION_NAME] = new List<MenuItem>();

    for (String name in subsectionNames) {
      map[name] = new List<MenuItem>();
    }

    return new Menu._(map);
  }

  // returns a list of subsection names for this menu
  List<String> getSubsectionNames() {
    return this.subsectionMap.keys;
  }

  // returns a list of all items in the menu
  // not ordered by subsection
  List<MenuItem> getAllItems() {
    var allItems = new List<MenuItem>();

    for (var subsectionList in subsectionMap.values) {
      allItems.addAll(subsectionList);
    }

    return allItems;
  }

  // adds an item to the right list of documents using its subsection name
  addItem(MenuItem item, bool isPopular) {
    if (item == null || item.subsection == null) {
      return;
    }

    // Add item to its normal subsection
    var subsectionList = subsectionMap[item.subsection];
    if (subsectionList == null) {
      return;
    }
    subsectionList.add(item);

    // Add item to the popular section if it is popular
    if (isPopular) {
      var popularSubsectionList = subsectionMap[POPULAR_ITEMS_SUBSECTION_NAME];
      if (popularSubsectionList == null) {
        return;
      }

      popularSubsectionList.add(item);
    }

    return;
  }
}

// makes a Menu object for the given restaurant
Future<Menu> buildMenuForRestaurant(Restaurant restaurant) async {
  final FirestoreManager _fsm = FirestoreManager();
  if (restaurant == null || restaurant.subsectionNames == null) {
    return null;
  }

  // make the menu object with the subsections filled out
  // (subsection strings still map to empty lists)
  var menu = Menu(restaurant.subsectionNames);

  // Get the Ids for the most popular items
  num topN = 5;
  List<dynamic> topItemsList = await _fsm.getTopFive(restaurant.id);
  List<String> topItemIds = new List(topN);
  if (topItemsList != null) {
    if (topItemsList.length < topN) {
      topN = topItemsList.length;
    }
    for (var i = 0; i < topN; i++) {
      topItemIds[i] = topItemsList[i]["itemId"];
    }
  }

  // add each item to the right list
  List<MenuItem> items = await getMenuItemsForRestaurant(restaurant.id);
  for (var item in items) {
    bool isPopular = topItemIds.contains(item.id);
    menu.addItem(item, isPopular);
  }

  return menu;
}
