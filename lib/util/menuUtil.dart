import 'package:bitewise/models/menu.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/services/fsmanager.dart';

class MenuUtil {

  // makes a Menu object for the given restaurant
  static Future<Menu> buildMenuForRestaurant(Restaurant restaurant) async {
    final FirestoreManager _fsm = FirestoreManager();
    if (restaurant == null || restaurant.subsectionNames == null) {
      return null;
    }

    // make the menu object with the subsections filled out
    // (subsection strings still map to empty lists)
    var menu = Menu(restaurant.subsectionNames);

    // Get the Ids for the most popular items
    num topN = 5;
    List<dynamic> topItemsList = await _fsm.getTopN(restaurant.id, topN);
    List<String> topItemIds = new List(topN);
    if (topItemsList != null) {
      if (topItemsList.length < topN) {
        topN = topItemsList.length;
      }
      for (var i = 0; i < topN; i++) {
        topItemIds[i] = topItemsList[i]["itemId"];
        menu.subsectionMap[Menu.POPULAR_ITEMS_SUBSECTION_NAME].add(null);
        print(i);
      }
    }

    // add each item to the right list
    List<MenuItem> items = await Documenu.getMenuItemsForRestaurant(restaurant.id);
    for (var item in items) {
      bool isPopular = topItemIds.contains(item.id);
      int popIndex = -1;
      if (isPopular) popIndex = topItemIds.indexOf(item.id);
      menu.addItem(item, isPopular, popIndex);
    }

    return menu;
  }
}
