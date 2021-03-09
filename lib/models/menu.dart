import 'dart:collection';
import 'package:bitewise/models/menuItem.dart';

class Menu {
  // Keep the subsections in order they were given from documenu
  // subsection name to list of menu items
  final LinkedHashMap<String, List<MenuItem>> subsectionMap;

  static const POPULAR_ITEMS_SUBSECTION_NAME = "Most Popular";
  final instanceMostPopName = POPULAR_ITEMS_SUBSECTION_NAME;
  final numMostPopular;

  Menu._(this.subsectionMap, this.numMostPopular);

  factory Menu(subsectionNames, numMostPopular) {
    if (subsectionNames == null) {
      return null;
    }
    Map<String, List<MenuItem>> map = new Map<String, List<MenuItem>>();
    map[POPULAR_ITEMS_SUBSECTION_NAME] = new List<MenuItem>(numMostPopular);

    for (String name in subsectionNames) {
      map[name] = new List<MenuItem>();
    }

    return new Menu._(map, numMostPopular);
  }

  // returns a list of subsection names for this menu
  List<String> getSubsectionNames() {
    return new List.from(this.subsectionMap.keys);
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
  addItem(MenuItem item, [int popularIndex]) {
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
    if (popularIndex != null) {
      var popularSubsectionList = subsectionMap[POPULAR_ITEMS_SUBSECTION_NAME];
      if (popularSubsectionList == null) {
        return;
      }
      popularSubsectionList[popularIndex] = item;
    }

    return;
  }
}