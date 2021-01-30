// Conection to Firebase APIs here
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitewise/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreManager {
  final AuthService _auth = AuthService();
  final Firestore _firestore = Firestore.instance;

  // variables for our collection names in firestore
  final String userCollection = "userInfo";
  final String ratingsCollection = "ratings";

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

  Future leaveRating(String itemId, num rating) async {
    try {
      FirebaseUser user = await _auth.getUser();
      if (user != null) {
        // If there is a current user, writeRating to the ratings collection
        // GCF in firebase/functions/index.js will update the average
        String uid = user.uid;
        await writeRating(itemId, rating, uid);
      } else {
        // prompt user to sign up if they are not in an authorized account
        promptToSignUp();
      }
    } catch (e) {
      print('err in leaveRating() :');
      print(e.toString());
    }
  }

  // Function that creates a rating document for menuItem
  // and adds it to the ratings collection
  Future writeRating(String itemId, num rating, String uid) async {
    try {
      _firestore.collection("ratings").add({
        "menuItemId": itemId,
        "rating": rating,
        "userUid": uid,
        "timestamp": Timestamp.now()
      }).then((value) {
        print('rating left for ' + itemId);
        print(value.documentID);
      });
    } catch (e) {
      print('err in writeRating() :');
      print(e.toString());
    }
    return;
  }

  // User tried to rate without being logged in,
  // prompt them to sign into (or create) an account
  Future promptToSignUp() async {
    // either takes them to a new page or pops up a modal for them to sign up
    print(
        'woah woah woah, hold your horses buddy. If you wanna leave a rating, you gotta sign up for an account. subway eat fresh.');
    return;
  }
}
