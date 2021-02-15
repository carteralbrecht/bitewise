import 'package:bitewise/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitewise/icons/my_flutter_app_icons.dart';

class RestaurantUtil {

  static Icon assignIcon(Restaurant r) {
    List<String> cuisines = r.cuisines;
    if (cuisines.first == "American" || cuisines.first == "Burgers" || cuisines.first == "Bar Food" || cuisines.first == "American (New)")
      return Icon(MyFlutterApp.big_cheeseburger, size: 50, color: Colors.grey);
    else if (cuisines.first == "Sandwiches" || cuisines.first == "Deli Food" || cuisines.first == "Diner" || cuisines.first == "Wraps")
      return Icon(MyFlutterApp.sandwich, size: 50, color: Colors.grey);
    else if (cuisines.first == "Pizza")
      return Icon(MyFlutterApp.pizza_slice, size: 50, color: Colors.grey);
    else if (cuisines.first == "Italian")
      return Icon(MyFlutterApp.spaghetti, size: 50, color: Colors.grey);
    else if (cuisines.first == "Chinese" || cuisines.first == "Japanese" || cuisines.first == "Asian")
      return Icon(MyFlutterApp.chinese_food, size: 50, color: Colors.grey);
    else if (cuisines.first == "Coffee &amp; Tea")
      return Icon(MyFlutterApp.coffee_cup, size: 50, color: Colors.grey);
    else if (cuisines.first == "Mexican")
      return Icon(MyFlutterApp.taco, size: 50, color: Colors.grey);
    else if (cuisines.first == "Salads" || cuisines.first == "Vegetarian")
      return Icon(MyFlutterApp.salad, size: 50, color: Colors.grey);
    else if (cuisines.first == "Bakery &amp; Pastries" || cuisines.first == "Bagel")
      return Icon(MyFlutterApp.croissant, size: 50, color: Colors.grey);
    else if (cuisines.first == "Sushi")
      return Icon(MyFlutterApp.nigiri, size: 50, color: Colors.grey);
    else if (cuisines.first == "Seafood")
      return Icon(MyFlutterApp.seafood, size: 50, color: Colors.grey);
    else if (cuisines.first == "Chicken")
      return Icon(MyFlutterApp.chicken_leg, size: 50, color: Colors.grey);
    else
      return Icon(MyFlutterApp.cutlery, size: 50, color: Colors.grey);
  }

}