import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/services/fsmanager.dart';
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

  // Get The Top N rated items from a list of restaurants
  // Return either the list of itemIds or actually build the MenuItem objects and return those as a list
  static Future<List<dynamic>> _getTopNFromMany(List<Restaurant> restaurants, int n, {buildMenuItems = false}) async {
    FirestoreManager _fsm = FirestoreManager();

    if (n <= 0) {
      return null;
    }

    // Hold all the top items we see
    List<dynamic> allTopItems = new List();

    // remember the rating of each item we see
    Map<String, double> ratingMap = new Map();

    // for each restaurant we are looking at
    for (Restaurant restaurant in restaurants) {

      // get the ratedItems list from the restaurant document in firestore
      dynamic ratedItemsList = await _fsm.getDocData(_fsm.restaurantCollection, restaurant.id, "ratedItems");

      // check if list was returned correctly
      if (!(ratedItemsList is List)) {
        continue;
      }

      // trim list to top n if more than n items
      // no sense in processing more than n
      if (ratedItemsList.length > n) {
        ratedItemsList = ratedItemsList.sublist(0, n);
      }

      // for each item in the ratedItems list
      for (var i = 0; i < ratedItemsList.length; i++) {

        var item = ratedItemsList[i];
        var itemId = item["itemId"].toString();
        var itemAvgRating = item["avgRating"].toDouble();

        // remember its avgRating
        ratingMap[itemId] = itemAvgRating;

        // add its id to the master list
        allTopItems.add(itemId);
      }
    }

    // sort the items by their ratings
    allTopItems.sort((a, b) {
      return ratingMap[b].compareTo(ratingMap[a]);
    });

    // take the top n
    if (allTopItems.length > n) {
      allTopItems = allTopItems.sublist(0, n);
    }


    // If we want the actual objects, build them and return them
    if (buildMenuItems) {
      List<dynamic> topItemObjects = new List();

      for (var itemId in allTopItems) {
        topItemObjects.add(Documenu.getMenuItem(itemId));
      }

      return topItemObjects;
    }

    // Otherwise we want the ids, so just return the master list which already has that
    else {
      return allTopItems;
    }

  }

  // Return the top N item id strings from a list of restaurants
  static Future<List<String>> getTopNItemIdsFromMany(List<Restaurant> restaurants, int n) async {
    var dynamicList = await _getTopNFromMany(restaurants, n, buildMenuItems: false);
    List<String> castedList = new List<String>.from(dynamicList);
    return castedList;
  }

  // Return the top N MenuItem OBJECTS from a list of restaurants
  static Future<List<Future<MenuItem>>> getTopNItemsFromMany(List<Restaurant> restaurants, int n) async {
    var dynamicList = await _getTopNFromMany(restaurants, n, buildMenuItems: true);
    List<Future<MenuItem>> castedList = new List<Future<MenuItem>>.from(dynamicList);
    return castedList;
  }

  // Return the top N item id strings from a restaurant
  static Future<List<String>> getTopNItemIds(Restaurant restaurant, int n) async {
    // treat the single restaurant as a list of size one
    List<Restaurant> singleRestaurantList = new List();
    singleRestaurantList.add(restaurant);
    return getTopNItemIdsFromMany(singleRestaurantList, n);
  }

  // Return the top N MenuItem OBJECTS from a restaurant
  static Future<List<Future<MenuItem>>> getTopNItems(Restaurant restaurant, int n) async {
    // treat the single restaurant as a list of size one
    List<Restaurant> singleRestaurantList = new List();
    singleRestaurantList.add(restaurant);
    return getTopNItemsFromMany(singleRestaurantList, n);
  }
}
