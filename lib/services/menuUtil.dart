import 'dart:collection';

import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/services/documenu.dart';

class Menu {
  final LinkedHashMap<String, List<MenuItem>> subsections;

  Menu._(this.subsections);

  factory Menu(subsectionNames) {

    Map<String, List<MenuItem>> map = new Map<String, List<MenuItem>>();
    for (String name in subsectionNames) {
      map[name] = new List<MenuItem>();
    }
    return new Menu._(map);
  }

  addItem(MenuItem item) {
    if (item == null || item.subsection == null) {
      return false;
    }

    var subsectionList = subsections[item.subsection];

    if (subsectionList == null) {
      return false;
    }

    return subsectionList.add(item);
  }
}

buildMenuForRestaurant(Restaurant restaurant) async {
  if (restaurant == null || restaurant.subsectionNames == null) {
    return null;
  }
  
  var menu = Menu(restaurant.subsectionNames);

  List<MenuItem> items = await getMenuItemsForRestaurant(restaurant.id);

  for (var item in items) {
    menu.addItem(item);
  }

  return menu;
}