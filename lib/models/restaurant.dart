import 'dart:convert';
import 'package:geolocator/geolocator.dart';

Restaurant restaurantFromJson(String str) {
  final jsonData = json.decode(str);
  return Restaurant.fromJson(jsonData);
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
    List<String> cuisinesList = cuisinesFromJson.cast<String>();

    var geoFromJson = json["geo"];
    Position position = new Position(latitude: geoFromJson["lat"], longitude: geoFromJson["lon"]);


    return new Restaurant(
        id: json["restaurant_id"],
        name: json["restaurant_name"],
        phone: json["restaurant_phone"],
        website: json["restaurant_website"],
        hours: json["hours"],
        priceRange: json["price_range"],
        cuisines: cuisinesList,
        geo: position
    );
  }
}