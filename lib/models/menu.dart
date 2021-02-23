import 'dart:collection';
import 'menuItem.dart';

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