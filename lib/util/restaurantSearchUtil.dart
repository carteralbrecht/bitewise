import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/util/geoUtil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantSearchUtil {

  static Future<String> findZip(Position p) async {
    if (p == null)
      return "";

    var placemarks = await placemarkFromCoordinates(p.latitude, p.longitude);
    var zip = placemarks.first.postalCode;

    return zip;
  }

  static Future<List<Restaurant>> searchByGeoAndName(Position p, String name) async {
    var zip = await findZip(p);
    var results = await searchByZipAndName(zip, name);

    final computedDistances = <Restaurant, double>{};
    for (Restaurant r in results) {
      computedDistances[r] = (await GeoUtil.distanceToRestaurant(p, r));
    }
    results.sort((a, b) => computedDistances[a].compareTo(computedDistances[b]));

    return results;
  }

  static Future<List<Restaurant>> searchByZipAndName(String zip, String name) async {

    // find restaurants whose name contains name and zip is zip
    List<Restaurant> results = await Documenu.searchRestaurantsZipName(zip, name);

    // filter out restaurants that only matched zip
    results.removeWhere((restaurant) => !restaurant.name.contains(name));

    return results;
  }

  static Future<List<Restaurant>> searchByGeo(Position p, int radius) async {
    List<Restaurant> results = await Documenu.searchRestaurantsGeo(
        p.latitude.toString(), p.longitude.toString(), radius.toString());

    return results;
  }
}