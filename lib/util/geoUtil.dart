import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// Contains useful geo methods

class GeoUtil {

  static const MILES_PER_METER = 0.000621371192;

  // converts meters to miles
  static double metersToMiles(double meters) {
    return meters * MILES_PER_METER;
  }

  // returns distance in miles between two lat lng
  static Future<double> milesBetween(lat1, lng1, lat2, lng2) async {
    var distanceMeters = Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
    return metersToMiles(distanceMeters);
  }

  // calculates the distance to a restaurant from the current location (in miles)
  static Future<double> distanceToRestaurant(Position p, Restaurant restaurant) async {
    return milesBetween(p.latitude, p.longitude, restaurant.geo.latitude, restaurant.geo.longitude);
  }

  // calculates the distance to a MenuItem from the current location (in miles)
  static Future<double> distanceToItem(Position p, MenuItem item) async {
    return milesBetween(p.latitude, p.longitude, item.geo.latitude, item.geo.longitude);
  }

  // returns the zip code string for a position
  static Future<String> findZip(Position p) async {
    if (p == null)
      return "";

    var placemarks = await placemarkFromCoordinates(p.latitude, p.longitude);
    var zip = placemarks.first.postalCode;

    return zip;
  }
}