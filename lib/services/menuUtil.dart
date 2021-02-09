import 'dart:collection';

import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/services/documenu.dart';

class Menu {
  // Keep the subsections in order they were given from documenu
  // subsection name to list of menu items
  final LinkedHashMap<String, List<MenuItem>> subsectionMap;

  Menu._(this.subsectionMap);

  factory Menu(subsectionNames) {
    Map<String, List<MenuItem>> map = new Map<String, List<MenuItem>>();
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
  addItem(MenuItem item) {
    if (item == null || item.subsection == null) {
      return false;
    }

    var subsectionList = subsectionMap[item.subsection];

    if (subsectionList == null) {
      return false;
    }

    return subsectionList.add(item);
  }
}

// makes a Menu object for the given restaurant
Future<Menu> buildMenuForRestaurant(Restaurant restaurant) async {
  if (restaurant == null || restaurant.subsectionNames == null) {
    return null;
  }

  // make the menu object with the subsections filled out
  // (subsection strings still map to empty lists)
  var menu = Menu(restaurant.subsectionNames);

  // add each item to the right list
  List<MenuItem> items = await getMenuItemsForRestaurant(restaurant.id);
  for (var item in items) {
    menu.addItem(item);
  }

  return menu;
}
