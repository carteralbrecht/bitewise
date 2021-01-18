import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GeoQueryManager {
  final geo = Geoflutterfire();
  final Firestore _firestore = Firestore.instance;

  Future getMenuItemsAt(double latitude, double longitude, double radius) async
  {
    try {
      GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);
      var collectionReference = _firestore.collection("menuitems");
      Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference).within(center: center, radius: radius, field: 'point');
      return stream;
    } catch (e) {
        print(e);
    }
    return;
  }

  Future getRestaurantsAt(double latitude, double longitude, double radius) async
  {
    try {
      GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);
      var collectionReference = _firestore.collection("restaurants");
      Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference).within(center: center, radius: radius, field: 'point');
      return stream;
    } catch (e) {
      print(e);
    }
    return;
  }
}
