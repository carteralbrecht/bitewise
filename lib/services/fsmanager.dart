// Conection to Firebase APIs here
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreManager {
  final Firestore _firestore = Firestore.instance;

  final String userCollectionName = "userInfo";

  Future findDocById(String collection, String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collection).document(id).get();
      if (doc == null || doc.exists == false) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print("error in findDocById() : " + e.toString());
      return false;
    }
  }

  Future deleteDocById(String collection, String id) async {
    try {
      await _firestore.collection(collection).document(id).delete();
      return "deleted";
    } catch (e) {
      print("error in findDocById() : " + e.toString());
      return e.toString();
    }
  }

  Future createUserInfo(String uid) async {
    try {
      List<String> ratedItems = [];
      _firestore
          .collection("userInfo")
          .document(uid)
          .setData({"ratedItems": ratedItems});
      return true;
    } catch (e) {
      print("err in createUserInfo() : " + e.toString());
      return false;
    }
  }
}
