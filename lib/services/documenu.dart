import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/models/menuItem.dart';

// TODO: Add API Key in Header
// https://documenu.com/docs#api_endpoint

final String baseUrl = "https://api.documenu.xyz/v2";

Future<Restaurant> getRestaurant(String id) async {
  final response = await http.get(baseUrl + "/restaurant/" + id);
  return restaurantFromJson(response.body);
}

Future<MenuItem> getMenuItem(String id) async {
  final response = await http.get(baseUrl + "/menuitem/" + id);
  return menuItemFromJson(response.body);
}