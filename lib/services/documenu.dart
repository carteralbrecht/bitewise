//import 'package:dotenv/dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Documenu {

  static const String AUTHORITY = "api.documenu.com";
  static final String key = env['DOCUMENU_KEY'];

// TODO: Add Error Handling
// TODO: Find better way to store key

  static Future<T> _getModel<T>(Uri uri, Function jsonBuilder) async {
    var file = await DefaultCacheManager().getSingleFile(uri.toString(), headers: {
      "X-API-KEY": key
    });
    
    if (file != null && await file.exists()) {
      var res = await file.readAsString();
      return jsonBuilder(res);
    }

    return null;
  }

  static Future<Restaurant> getRestaurant(String id) async {
    var uri = Uri.https(AUTHORITY, "/v2/restaurant/$id");

    return _getModel<Restaurant>(uri, restaurantFromJson);
  }

  static Future<MenuItem> getMenuItem(String id) async {
    var uri = Uri.https(AUTHORITY, "/v2/menuitem/$id");

    return _getModel<MenuItem>(uri, menuItemFromJson);
  }

  static Future<List<Restaurant>> searchRestaurantsGeo(String lat, String lng, String radius) async {
    var queryParameters = {
      'lat': lat,
      'lon': lng,
      'distance': radius,
      'fullmenu': 'true'
    };

    var uri = Uri.https(AUTHORITY, "/v2/restaurants/search/geo", queryParameters);

    return _getModel<List<Restaurant>>(uri, restaurantsFromJson);
  }

  static Future<List<MenuItem>> getMenuItemsForRestaurant(String id) async {
    var uri = Uri.https(AUTHORITY, "/v2/restaurant/$id/menuitems");

    return _getModel<List<MenuItem>>(uri, menuItemsFromJson);
  }

  static Future<List<Restaurant>> searchRestaurantsZipName(String zip, String restaurantName) async {

    var queryParameters = {
      'restaurant_name': restaurantName,
      'zip_code': zip,
      'fullmenu': 'true'
    };

    var uri = Uri.https(AUTHORITY, "v2/restaurants/search/fields", queryParameters);

    return _getModel<List<Restaurant>>(uri, restaurantsFromJson);
  }
}