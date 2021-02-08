import 'dart:convert';
import 'package:bitewise/models/menuItem.dart';
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
  final String address;
  final List<String> subsectionNames;

  Restaurant({
    this.id,
    this.name,
    this.phone,
    this.website,
    this.hours,
    this.priceRange,
    this.cuisines,
    this.geo,
    this.address,
    this.subsectionNames
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    var cuisinesFromJson = json["cuisines"];
    List<String> cuisinesList = cuisinesFromJson?.cast<String>();

    var geoFromJson = json["geo"];
    Position position = geoFromJson == null ? null : new Position(latitude: geoFromJson["lat"], longitude: geoFromJson["lon"]);

    var addressFromJson = json["address"];
    String formattedAddress = addressFromJson == null ? null : addressFromJson["formatted"];

    List<String> subsections = new List();
    var menus = json["menus"];

    for (var menu in menus) {
      for (var section in menu["menu_sections"]) {
        subsections.add(section["section_name"]);
      }
    }

    return new Restaurant(
        id: json["restaurant_id"].toString(),
        name: json["restaurant_name"].toString(),
        phone: json["restaurant_phone"].toString(),
        website: json["restaurant_website"].toString(),
        hours: json["hours"].toString(),
        priceRange: json["price_range"].toString(),
        cuisines: cuisinesList,
        geo: position,
        address: formattedAddress,
        subsectionNames: subsections
    );
  }
}

// Ben needs A list of subsections where each subsection has a list of MenuItems
// The names of the subsections are known when the Restaurant object is created
// The items in those subsections are populated later