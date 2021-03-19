//import 'package:dotenv/dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/models/menuItem.dart';

class Documenu {

  static const String AUTHORITY = "api.documenu.com";
  static final String key = env['DOCUMENU_KEY'];

// TODO: Add Error Handling
// TODO: Find better way to store key

  static Future<Restaurant> getRestaurant(String id) async {
    var uri = Uri.https(AUTHORITY, "/v2/restaurant/$id");

    final response = await http.get(uri, headers: {
      "X-API-KEY": key
    });

    return restaurantFromJson(response.body);
  }

  static Future<MenuItem> getMenuItem(String id) async {
    var uri = Uri.https(AUTHORITY, "/v2/menuitem/$id");

    final response = await http.get(uri, headers: {
      "X-API-KEY": key
    });

    return menuItemFromJson(response.body);
  }

  static Future<List<Restaurant>> searchRestaurantsGeo(String lat, String lng, String radius) async {
    var queryParameters = {
      'lat': lat,
      'lon': lng,
      'distance': radius,
      'fullmenu': 'true'
    };

    var uri = Uri.https(AUTHORITY, "/v2/restaurants/search/geo", queryParameters);

    final response = await http.get(uri, headers: {
      "X-API-KEY": key
    });

    return restaurantsFromJson(response.body);
  }

  static Future<List<MenuItem>> searchMenuItemsGeo(String lat, String lng, String radius, String query) async {
    var queryParameters = {
      'lat': lat,
      'lon': lng,
      'distance': radius,
      'search': query
    };

    var uri = Uri.https(AUTHORITY, "/v2/menuitems/search/geo", queryParameters);

    final response = await http.get(uri, headers: {
      "X-API-KEY": key
    });

    return menuItemsFromJson(response.body);
  }

  static Future<List<MenuItem>> getMenuItemsForRestaurant(String id) async {
    var uri = Uri.https(AUTHORITY, "/v2/restaurant/$id/menuitems");

    final response = await http.get(uri, headers: {
      "X-API-KEY": key
    });

    return menuItemsFromJson(response.body);
  }

  static Future<List<Restaurant>> searchRestaurantsZipName(String zip, String restaurantName) async {

    var queryParameters = {
      'restaurant_name': restaurantName,
      'zip_code': zip,
      'fullmenu': 'true'
    };

    var uri = Uri.https(AUTHORITY, "v2/restaurants/search/fields", queryParameters);

    final response = await http.get(uri, headers: {
      "X-API-KEY": key
    });

    return restaurantsFromJson(response.body);
  }
}