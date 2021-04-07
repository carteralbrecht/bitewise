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

    // Get the Ids for the most popular items
    List<String> mostPopularItemIds =
        await RestaurantUtil.getTopNItemIds(restaurant, numMostPopular);

    // add each item to the right list
    List<MenuItem> allMenuItemsForRestaurant =
        await Documenu.getMenuItemsForRestaurant(restaurant.id);

    // check for popular items in Firestore that don't exist from the current data provider
    var popularIdsUnavailable = [];

    // For each of the popular item ids given from firestore
    for (String itemId in mostPopularItemIds) {
      
      // set flag to false initially
      bool seen = false;

      // check all the items given from the data provider
      for (MenuItem item in allMenuItemsForRestaurant) {
        // set flag to true if the current popular item is found from the data provider
        if (item.id == itemId) {
          seen = true;
          break;
        }
      }

      // if we reach here and have not seen the current popular item, mark it for removal
      if (!seen) {
        print(itemId);
        popularIdsUnavailable.add(itemId);
      }
    }

    // remove those popular items which we do not have available from the current data provider
    for (var id in popularIdsUnavailable) {
      mostPopularItemIds.remove(id);
    }

    // if there aren't enough valid popular items for the desired length
    if (mostPopularItemIds.length < numMostPopular) {
      numMostPopular = mostPopularItemIds.length;
    }

    // make the menu object with the subsections filled out
    // (subsection strings still map to empty lists)
    var menu = Menu(restaurant.subsectionNames, numMostPopular);

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
