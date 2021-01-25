import 'dart:convert';
import 'package:geolocator/geolocator.dart';

// Menu Item data model from Documenu API
// https://documenu.com/docs#get_menu_item

MenuItem menuItemFromJson(String str) {
  final jsonData = json.decode(str);
  return MenuItem.fromJson(jsonData["result"]);
}

List<MenuItem> menuItemsFromJson(String str) {
  final jsonData = json.decode(str);

  var decodedMenuItems = jsonData["data"];

  List<MenuItem> menuItems = new List();

  for (Map<String, dynamic> json in decodedMenuItems) {
    menuItems.add(MenuItem.fromJson(json));
  }

  return menuItems;
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
    Position position = geoFromJson == null ? null : new Position(latitude: geoFromJson["lat"], longitude: geoFromJson["lon"]);

    return new MenuItem(
        id: json["item_id"].toString(),
        name: json["menu_item_name"].toString(),
        description: json["menu_item_description"].toString(),
        price: json["menu_item_price"].toString(),
        priceRange: json["price_range"].toString(),
        restaurantId: json["restaurant_id"].toString(),
        subsection: json["subsection"].toString(),
        subsectionDescription: json["subsection_description"].toString(),
        geo: position
    );
  }
}