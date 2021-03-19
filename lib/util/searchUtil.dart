import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/util/geoUtil.dart';
import 'package:geolocator/geolocator.dart';

// Contains useful methods for searching for restaurants by location and location+name

class SearchUtil {

  // Search for a restaurant by Geo and Name
  // Have to convert the position to a zip code due to documenu functionality
  static Future<List<Restaurant>> restaurantByGeoAndName(Position p, String name) async {

    // get the zip code for the position
    var zip = await GeoUtil.findZip(p);

    // search restaurants by zip code and name
    var results = await restaurantByZipAndName(zip, name);

    // compute their distances in order to sort them with respect to distance from p
    final computedDistances = <Restaurant, double>{};
    for (Restaurant r in results) {
      computedDistances[r] = (await GeoUtil.distanceToRestaurant(p, r));
    }
    results.sort((a, b) => computedDistances[a].compareTo(computedDistances[b]));

    return results;
  }

  // search restaurants by zipcode and name
  static Future<List<Restaurant>> restaurantByZipAndName(String zip, String name) async {

    // find restaurants whose name contains name and zip is zip
    List<Restaurant> results = await Documenu.searchRestaurantsZipName(zip, name);

    // filter out restaurants that only matched zip
    results.removeWhere((restaurant) => !restaurant.name.toLowerCase().contains(name.toLowerCase()));

    // return only restaurants whose name had a partial (or full) match
    return results;
  }

  // search restaurants by position and radius
  static Future<List<Restaurant>> restaurantByGeo(Position p, int radius) async {
    List<Restaurant> results = await Documenu.searchRestaurantsGeo(
        p.latitude.toString(), p.longitude.toString(), radius.toString());

    return results;
  }

  // search menu items by position, radius, and search term (name and description)
  static Future<List<MenuItem>> menuItemByGeoAndName(Position p, int radius, String query) async {
    List<MenuItem> results = await Documenu.searchMenuItemsGeo(
        p.latitude.toString(), p.longitude.toString(), radius.toString(), query);

    return results;
  }
}