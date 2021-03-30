import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bitewise/models/menu.dart';
import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:bitewise/util/geoUtil.dart';
import 'package:bitewise/util/itemListUtil.dart';
import 'package:bitewise/util/restaurantUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bitewise/global.dart' as global;
import 'package:bitewise/pages/restaurantPage.dart';
import 'package:bitewise/services/auth.dart';
import 'package:bitewise/util/searchUtil.dart';
import 'package:bitewise/models/restaurant.dart';
import 'package:bitewise/components/mostPopularItemCard.dart';
import '../components/restaurantListTile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:bitewise/components/menuItemSearchTile.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final FirestoreManager _fsm = FirestoreManager();
  GoogleMapController mapController;
  Position currentLocation;
  Stack _homePage;
  var restaurantsNearUser;
  var restaurantDistances;
  Uint8List markerIcon;
  String _mapStyle;
  bool isSheetMax = false;
  bool isSearchActive = false;
  List<Widget> restSearchResults = new List<Widget>();
  List<Widget> itemSearchResults = new List<Widget>();
  TextEditingController searchController = new TextEditingController();
  FocusNode searchFocus = new FocusNode();
  int _currentCarouselIndex = 0;
  List<Widget> mostPopItems;
  Widget _googleMap;
  List<bool> isSelected = [true, false];
  TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    setPinImage();
    getUserLocation();
    getRestaurantsNearby();
    rootBundle.loadString('assets/MapStyle.txt').then((string) {
      _mapStyle = string;
    });
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() { 
      setState(() {
        tabIndex = tabController.index;
      });
    });
    
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);

  }

  void setPinImage() async {
    ByteData data = await rootBundle.load('assets/pin.png');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 120, targetHeight: 130);
    ui.FrameInfo fi = await codec.getNextFrame();
    markerIcon = (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void getUserLocation() async {
    Position result = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = result;
    });
  }

  Future<List<Future<MenuItem>>> getTopNItemsFromResults(int n) async {
    List<Future<MenuItem>> topItemsNear = await RestaurantUtil.getTopNItemsFromMany(restaurantsNearUser, n);
    return topItemsNear;
  }

  void getRestaurantsNearby() async {
    // Don't fetch restaurants until we have a current location for the user
    while (currentLocation == null) {
      await Future.delayed(Duration(milliseconds: 500));
    }

    var restaurants = await SearchUtil.restaurantByGeo(currentLocation, 2);

    List<Restaurant> resultsNear = new List<Restaurant>();
    List<double> restDistances = new List<double>();

    for (Restaurant restaurant in restaurants) {
      resultsNear.add(restaurant);
      restDistances.add(await GeoUtil.distanceToRestaurant(currentLocation, restaurant));
    }

    setState(() {
      restaurantsNearUser = resultsNear;
      restaurantDistances = restDistances;

      getTopItems();
      // create the map when restaurants are finished being fetched
      _googleMap = createMap();
    });
  }

  Set<Marker> _createMarkers() {
    final Set<Marker> markersSet = {};

    for (Restaurant restaurant in restaurantsNearUser) {
      markersSet.add(Marker(
        markerId: MarkerId(restaurant.name),
        position: LatLng(restaurant.geo.latitude, restaurant.geo.longitude),
        infoWindow: InfoWindow(
            title: restaurant.name,
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantPage(restaurant: restaurant)))
                }),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));
    }

    return markersSet;
  }

  Widget createMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 15.0,
      ),
      markers: _createMarkers(),
      myLocationEnabled: true,
      myLocationButtonEnabled: false
    );
  }

  void getTopItems() async {
    List<Future<MenuItem>> items = await RestaurantUtil.getTopNItemsFromMany(restaurantsNearUser, 3);
    List<Widget> itemWidgetList = new List<Widget>();

    for (Future<MenuItem> i in items) {
      MenuItem mi = await i;
      Restaurant rs;
      for (Restaurant r in restaurantsNearUser) {
        if (r.id == mi.restaurantId) {
          rs = r;
          break;
        }
      }
      var avg = await _fsm.getDocData(_fsm.menuItemCollection, mi.id, "avgRating");
      itemWidgetList.add(new MostPopularItemCard(mi, avg, restaurant: rs));
    }


    setState(() {
      mostPopItems = itemWidgetList;
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  void getSearchRestaurant(String s) async {
    var restList = await SearchUtil.restaurantByGeoAndName(currentLocation, s);
    
    List<Widget> restWidgets = new List<Widget>();
    for (Restaurant r in restList) {
      restWidgets.add(
        FlatButton(
          onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantPage(restaurant: r)))
              },
          child: RestaurantListTile(r, await GeoUtil.distanceToRestaurant(currentLocation, r))
        ),
        
      );
    }

    if (restWidgets.length == 0) {
      restWidgets.add(
        FlatButton(
          color: Colors.white,
          onPressed: () {
            
          },
          child: Text("No Results", style: TextStyle(fontSize: 20, color: Colors.black)),
        )
      );
    }

    setState(() {
      restSearchResults = restWidgets;
    });
  }

  void getSearchItem(String s) async {
    var itemList = await SearchUtil.menuItemByGeoAndName(currentLocation, 20, s);
    
    List<Widget> itemWidgets = new List<Widget>();

    for (MenuItem i in itemList) {
      Future<Restaurant> r = Documenu.getRestaurant(i.restaurantId);
      var avg = await _fsm.getDocData(_fsm.menuItemCollection, i.id, "avgRating");
      var dist = await GeoUtil.distanceToItem(currentLocation, i);
      itemWidgets.add(
        FlatButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantPage(futureRestaurant: r, itemId: i.id)));
          },
          child: new MenuItemSearchTile(i, r, avg, dist),
        ),
      );
    }

    if (itemWidgets.length == 0) {
      itemWidgets.add(
        FlatButton(
          color: Colors.white,
          onPressed: () {
            
          },
          child: Text("No Results", style: TextStyle(fontSize: 20, color: Colors.black)),
        )
      );
    }

    setState(() {
      itemSearchResults = itemWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: global.mainColor,
        elevation: 0,
        title: Container(
          margin: EdgeInsets.only(left: 0, right: 0),
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 40,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.search, size: 26.0, color: global.accentGrayDark),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, top:18.5),
                    alignment: Alignment.bottomLeft,
                    child: TextFormField(
                      focusNode: searchFocus,
                      controller: searchController,
                      textAlignVertical: TextAlignVertical.bottom,
                      style: TextStyle(fontSize: 20),
                      onChanged: (val) {
                        print("Tab Index" + tabIndex.toString());
                        EasyDebounce.debounce(
                              'restaurant-search-debouncer',
                              Duration(milliseconds: 500),
                              () => tabIndex == 0 ? getSearchRestaurant(val) : getSearchItem(val));
                      },
                      onTap: () {
                        setState(() {
                          isSearchActive = true;
                        });
                      },
                      // readOnly: !isSearchActive,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(fontSize: 20, color: global.accentGrayDark),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                isSearchActive ? Container(
                  alignment: Alignment.centerRight, 
                  child: GestureDetector(
                    onTap: () {
                      searchController.clear();
                      searchFocus.unfocus();
                      setState(() {
                        getSearchRestaurant("");
                        getSearchItem("");
                        isSearchActive = false;
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      size: 26,
                      color: global.accentGrayDark,
                    ),
                  )
                ) : Container(height: 0, width: 0),
              ]),
        ),
        actions: <Widget>[
          Container(
              height: 35,
              width: 35,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  if (global.user == null) {
                    Navigator.pushNamed(context, '/signin');
                  } else {
                    Navigator.pushNamed(context, '/profile');
                  }
                },
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: global.mainColor,
                ),
              )),
        ],
      ),
      body: Stack(
        children: <Widget>[
          (_googleMap != null ? _googleMap : Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(global.mainColor),
            )
          )),
          mostPopItems == null || mostPopItems?.length == 0 ? Container(height:0, width:0) : Positioned(
            top:0,
            right:0,
            child: Container(
              margin: EdgeInsets.all(10),
              width: 220,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 50,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 4),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                    ),
                    items: mostPopItems == null ? [Container(height:0, width:0)] : mostPopItems,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(mostPopItems, (index, url) {
                      return Container(
                        width: 5.0,
                        height: 5.0,
                        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentCarouselIndex == index ? global.accentGrayDark : global.accentGrayLight,
                        ),
                      );
                    }),
                  ),
                ]
              ),
            ),
          ),
          restaurantsNearUser == null ? Container(height: 0, width: 0) : DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 1,
            builder: (BuildContext context, _scrollController) {
              _scrollController.addListener(() {
                setState(() {
                  isSheetMax = _scrollController.offset >= 0;
                });
                print(_scrollController.offset.toString());
              });
              return Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: isSheetMax ? BorderRadius.zero : BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: restaurantsNearUser.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 5,
                            width: 60,
                            margin: EdgeInsetsDirectional.only(top: 10, bottom: 5),
                            decoration: new BoxDecoration(
                              color: global.accentGrayDark,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ));
                    }
                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RestaurantPage(
                                            restaurant: restaurantsNearUser[index - 1])))
                              },
                          child: RestaurantListTile(restaurantsNearUser[index - 1],
                              restaurantDistances[index - 1])
                        ),
                        Divider(
                          color: global.accentGrayLight,
                          height: 5,
                          thickness: 5,
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
          // isSearchActive ?  Column(
          //   children: [
          //     Container(
          //       child: ToggleButtons(
          //         children: <Widget>[
          //           Text("Restaurants"),
          //           Text("Menu Items"),
          //         ],
          //         isSelected: isSelected,
          //         onPressed: (int index) {
          //           setState(() {
          //             isSelected[index] = true;
          //             isSelected[(index + 1) % 2] = false;
          //           });
          //         },
          //       ),
          //     ),
          //     Container(
          //       color: Colors.white,
          //       child: ListView(
          //         children: isSelected[0] ? restSearchResults : itemSearchResults,
          //       ),
          //     )
          //   ],
          // ) : Container(height: 0, width: 0),

          isSearchActive ? DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: global.mainColor,
                title: TabBar(
                  labelColor: Colors.black,
                  labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontSize: 20),
                  indicatorColor: Colors.black,
                  onTap: (index) {

                  },
                  tabs: <Widget>[
                    Tab(
                      text: "Restaurants",
                    ),
                    Tab(
                      text: "Menu Items",
                    ),
                  ],
                  controller: tabController,

                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: ListView(
                      children: restSearchResults,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: ListView(
                      children: itemSearchResults,
                    ),
                  ),
                ],
                controller: tabController,

              ),
            )
          ) : Container(height: 0, width: 0)
        ]
      ),
    );
  }
}
