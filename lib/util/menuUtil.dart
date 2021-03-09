import 'package:bitewise/models/menu.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/util/restaurantUtil.dart';

class MenuUtil {

  // makes a Menu object for the given restaurant
  static Future<Menu> buildMenuForRestaurant(Restaurant restaurant, {int numMostPopular = 5}) async {

    if (restaurant == null || restaurant.subsectionNames == null) {
      return null;
    }

    // make the menu object with the subsections filled out
    // (subsection strings still map to empty lists)
    var menu = Menu(restaurant.subsectionNames, numMostPopular);

    // Get the Ids for the most popular items
    List<String> mostPopularItemIds = await RestaurantUtil.getTopNItemIds(restaurant, numMostPopular);

    // add each item to the right list
    List<MenuItem> allMenuItemsForRestaurant = await Documenu.getMenuItemsForRestaurant(restaurant.id);

    for (var item in allMenuItemsForRestaurant) {
      // if item is popular also pass in its index
      if (mostPopularItemIds.contains(item.id)) {
        menu.addItem(item, mostPopularItemIds.indexOf(item.id));
      } else {
        menu.addItem(item);
      }
    }

    return menu;
  }
}
