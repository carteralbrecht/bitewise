import 'package:bitewise/models/menu.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/util/menuUtil.dart';
import 'package:bitewise/util/restaurantSearchUtil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test/test.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:dotenv/dotenv.dart' show load;

void main() async {
  setUp(() {
    // load api key from .env
    // this won't work unless you use dotenv/dotenv
    // whenever env values are read in the app
    load();
  });

  // Does a GET on a Restaurant ID and checks that it returns the correct restaurant name
  test('GetRestaurant', () async {
    var restaurant = await Documenu.getRestaurant("2859720081221600");
    expect(restaurant.name, "Panera Bread");
  });

  test('Build Menu', () async {
    var restaurant = await Documenu.getRestaurant("2859723381214996");
    Menu menu = await MenuUtil.buildMenuForRestaurant(restaurant);
    expect(menu.getSubsectionNames().contains("Mobile Hot Coffee"), true);
  });

  // Does a GET on a menu item ID and checks that it returns the correct item name
  test('GetMenuItem', () async {
    var menuItem = await Documenu.getMenuItem("8840854639283264567");
    expect(menuItem.name, "Hook & Ladder®");
  });

  // Does a restaurant search by location
  // Checks one of the results
  test('searchByGeo', () async {
    var restaurants = await RestaurantSearchUtil.searchByGeo(
        Position(longitude: -77.17103, latitude: 39.114805), 2);

    var shouldContain = "Baja Fresh";
    var doesContain = false;

    for (Restaurant restaurant in restaurants) {
      if (restaurant.name == shouldContain) {
        doesContain = true;
        break;
      }
    }
    expect(doesContain, true);
  });

  test('SearchRestaurantsZipName', () async {
    var restaurants = await RestaurantSearchUtil.searchByZipAndName("32817", "Panera");

    expect(restaurants.first.name.contains("Panera"), true);
  });

  // Gets the menu items for a restaurant by the restaurant id
  // Checks one of the results
  test('MenuItemsForRestaurant', () async {
    var restaurant = await Documenu.getRestaurant("2859723381214996");

    var menuItems = await Documenu.getMenuItemsForRestaurant(restaurant.id);

    var shouldContain = "Sun Up Large Eggs";
    var doesContain = false;

    for (MenuItem item in menuItems) {
      if (item.name == shouldContain) {
        doesContain = true;
        break;
      }
    }

    expect(doesContain, true);
  });
}
