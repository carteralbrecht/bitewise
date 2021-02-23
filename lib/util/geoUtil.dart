import 'package:bitewise/models/restaurant.dart';
import 'package:geolocator/geolocator.dart';

class GeoUtil {

  static const MILES_PER_METER = 0.000621371192;
  static final _geoLocator = Geolocator();

  static double metersToMiles(double meters) {
    return meters * MILES_PER_METER;
  }

  static Future<double> milesBetween(lat1, lng1, lat2, lng2) async {
    var distanceMeters = await _geoLocator.distanceBetween(lat1, lng1, lat2, lng2);
    return metersToMiles(distanceMeters);
  }

  // calculates the distance to a restaurant from the current location (in miles)
  static Future<double> distanceToRestaurant(Position p, Restaurant restaurant) async {
    return milesBetween(p.latitude, p.longitude, restaurant.geo.latitude, restaurant.geo.longitude);
  }

  static void sortByDistance(List<Restaurant> list, Position p) async {

    final computedDistances = <Restaurant, double>{};

    for (Restaurant r in list) {
      computedDistances[r] = (await distanceToRestaurant(p, r));
    }

    list.sort((a, b) => computedDistances[a].compareTo(computedDistances[b]));
  }

}