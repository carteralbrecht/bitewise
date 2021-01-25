import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test/test.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:dotenv/dotenv.dart' show load;

void main() async {

  // load api key from .env
  load();

  setUp(() {
    // setup goes here
  });

  // Does a GET on a Restaurant ID and checks that it returns the correct restaurant name
  test('GetRestaurant', () async {
    var restaurant = await getRestaurant("2859720081221600");
    expect(restaurant.name, "Panera Bread");
  });

  // Does a GET on a menu item ID and checks that it returns the correct item name
  test('GetMenuItem', () async {
    var menuItem = await getMenuItem("8840854639283264567");
    expect(menuItem.name, "Hook & Ladder®");
  });

  // Does a restaurant search by location
  // Checks one of the results
  test('SearchRestaurantsGeo', () async {
    var restaurants = await searchRestaurantsGeo(
        Position(longitude: -77.17103, latitude: 39.114805),
        2);

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

  // Gets the menu items for a restaurant by the restaurant id
  // Checks one of the results
  test('MenuItemsForRestaurant', () async {
    var restaurant = await getRestaurant("2859723381214996");

    var menuItems = await getMenuItemsForRestaurant(restaurant.id);

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