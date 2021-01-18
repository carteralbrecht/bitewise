import 'dart:convert';
import 'package:geolocator/geolocator.dart';

MenuItem menuItemFromJson(String str) {
  final jsonData = json.decode(str);
  return MenuItem.fromJson(jsonData);
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final String price;
  final String priceRange;
  final String restaurantId;
  final String subsection;
  final String subsectionDescription;
  final Position geo;

  MenuItem({
    this.id,
    this.name,
    this.description,
    this.price,
    this.priceRange,
    this.restaurantId,
    this.subsection,
    this.subsectionDescription,
    this.geo
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    var geoFromJson = json["geo"];
    Position position = new Position(latitude: geoFromJson["lat"], longitude: geoFromJson["lon"]);

    return new MenuItem(
        id: json["item_id"],
        name: json["menu_item_name"],
        description: json["menu_item_description"],
        price: json["menu_item_price"],
        priceRange: json["price_range"],
        restaurantId: json["restaurant_id"],
        subsection: json["subsection"],
        subsectionDescription: json["subsection_description"],
        geo: position
    );
  }
}