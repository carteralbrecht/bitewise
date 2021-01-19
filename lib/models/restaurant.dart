import 'dart:convert';
import 'package:geolocator/geolocator.dart';

// Restaurant data model from Documenu API
// https://documenu.com/docs#get_restaurant

Restaurant restaurantFromJson(String str) {
  final jsonData = json.decode(str);
  return Restaurant.fromJson(jsonData["result"]);
}

List<Restaurant> restaurantsFromJson(String str) {
  final jsonData = json.decode(str);

  var decodedRestaurants = jsonData["data"];

  List<Restaurant> restaurants = new List();

  for (Map<String, dynamic> json in decodedRestaurants) {
    restaurants.add(Restaurant.fromJson(json));
  }

  return restaurants;
}

class Restaurant {
  final String id;
  final String name;
  final String phone;
  final String website;
  final String hours;
  final String priceRange;
  final List<String> cuisines;
  final Position geo;

  Restaurant({
    this.id,
    this.name,
    this.phone,
    this.website,
    this.hours,
    this.priceRange,
    this.cuisines,
    this.geo
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    var cuisinesFromJson = json["cuisines"];
    List<String> cuisinesList = cuisinesFromJson?.cast<String>();

    var geoFromJson = json["geo"];
    Position position = geoFromJson == null ? null : new Position(latitude: geoFromJson["lat"], longitude: geoFromJson["lon"]);


    return new Restaurant(
        id: json["restaurant_id"].toString(),
        name: json["restaurant_name"].toString(),
        phone: json["restaurant_phone"].toString(),
        website: json["restaurant_website"].toString(),
        hours: json["hours"].toString(),
        priceRange: json["price_range"].toString(),
        cuisines: cuisinesList,
        geo: position
    );
  }
}