import 'package:bitewise/models/menu.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/services/documenu.dart';

class MenuUtil {
  // makes a Menu object for the given restaurant
  static Future<Menu> buildMenuForRestaurant(Restaurant restaurant) async {
    if (restaurant == null || restaurant.subsectionNames == null) {
      return null;
    }

    // make the menu object with the subsections filled out
    // (subsection strings still map to empty lists)
    var menu = Menu(restaurant.subsectionNames);

    // add each item to the right list
    List<MenuItem> items = await Documenu.getMenuItemsForRestaurant(restaurant.id);
    for (var item in items) {
      menu.addItem(item);
    }

    return menu;
  }
}
