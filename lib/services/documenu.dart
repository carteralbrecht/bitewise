//import 'package:dotenv/dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/models/menuItem.dart';

final String authority = "api.documenu.com";
final String key = env['DOCUMENU_KEY'];

// TODO: Add Error Handling
// TODO: Find better way to store key

Future<Restaurant> getRestaurant(String id) async {
  var uri = Uri.https(authority, "/v2/restaurant/$id");

  final response = await http.get(uri, headers: {
    "X-API-KEY": key
  });

  return restaurantFromJson(response.body);
}

Future<MenuItem> getMenuItem(String id) async {
  var uri = Uri.https(authority, "/v2/menuitem/$id");

  final response = await http.get(uri, headers: {
    "X-API-KEY": key
  });

  return menuItemFromJson(response.body);
}

Future<List<Restaurant>> searchRestaurantsGeo(Position geo, int radius) async {
  var queryParameters = {
    'lat': geo.latitude.toString(),
    'lon': geo.longitude.toString(),
    'distance': radius.toString(),
    'fullmenu': 'true'
  };

  var uri = Uri.https(authority, "/v2/restaurants/search/geo", queryParameters);

  final response = await http.get(uri, headers: {
    "X-API-KEY": key
  });

  return restaurantsFromJson(response.body);
}

Future<List<MenuItem>> getMenuItemsForRestaurant(String id) async {
  var uri = Uri.https(authority, "/v2/restaurant/$id/menuitems");

  final response = await http.get(uri, headers: {
    "X-API-KEY": key
  });

  return menuItemsFromJson(response.body);
}

