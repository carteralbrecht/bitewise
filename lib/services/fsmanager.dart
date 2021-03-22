// Conection to Firebase APIs here
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitewise/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreManager {

  static final FirestoreManager _instance = FirestoreManager._internal();

  final AuthService _authServ = AuthService();
  final Firestore _firestore = Firestore.instance;

  // variables for our collection names in firestore
  final String userCollection = "userInfo";
  final String ratingsCollection = "ratings";
  final String menuItemCollection = "menuitems";
  final String restaurantCollection = "restaurants";

  factory FirestoreManager() {
    return _instance;
  }

  FirestoreManager._internal();

  Future getMenuItemStream(String id) async {
    try {
      Stream<DocumentSnapshot> stream = await _firestore
          .collection(menuItemCollection)
          .document(id)
          .snapshots();
      if (stream == null) {
        return null;
      } else {
        return stream;
      }
    } catch (e) {
      print("error in getMenuItemForStream() : " + e.toString());
      return null;
    }
  }

  Future findDocById(String collection, String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collection).document(id).get();
      if (doc == null || doc.exists == false) {
        return null;
      } else {
        return doc;
      }
    } catch (e) {
      print("error in findDocById() : " + e.toString());
      return null;
    }
  }

  Future deleteDocById(String collection, String id) async {
    try {
      await _firestore.collection(collection).document(id).delete();
      return "deleted";
    } catch (e) {
      print("error in deleteDocById() : " + e.toString());
      return e.toString();
    }
  }

  Future getDocData(String collection, String id, String data) async {
    try {
      DocumentSnapshot doc = await findDocById(collection, id);
      if (doc == null || doc.exists == false) {
        // doc DNE
        return null;
      }
      return (doc[data]);
    } catch (e) {
      print("error in getDocData() : " + e.toString());
      return null;
    }
  }

  Future leaveRating(String restId, String itemId, num rating) async {
    try {
      FirebaseUser user = await _authServ.getUser();
      if (user != null) {
        // If there is a current user, writeRating to the ratings collection
        // GCF in firebase/functions/index.js will update the average
        String uid = user.uid;
        dynamic rateId = await getUserRating(uid, itemId);
        // updateExisting will return false if there was not a rating to update
        if (rateId == null) {
          await writeRating(uid, restId, itemId, rating);
        } else {
          await updateExistingRating(rateId, rating);
        }
      } else {
        // prompt user to sign up if they are not in an authorized account
        promptToSignUp();
      }
    } catch (e) {
      print('err in leaveRating() :');
      print(e.toString());
    }
  }

  // Function to return a rating for an item left by the given user
  // returns null if that item does not exist
  Future getUserRating(String uid, String itemid) async {
    try {
      // search for doc in ratings where userUid = uid and menuItemId = itemId
      List<DocumentSnapshot> ratingDoc;
      ratingDoc = (await Firestore.instance
              .collection(ratingsCollection)
              .where("userUid", isEqualTo: uid)
              .where("menuItemId", isEqualTo: itemid)
              .getDocuments())
          .documents;

      // if it does not exist, return null
      if (ratingDoc.isEmpty) {
        print("no rating for " + itemid + " left by " + uid);
        return null;
      } else {
        return ratingDoc[0].documentID;
      }
    } catch (e) {
      print("Error in updateExistingRating(): " + e.toString());
      return null;
    }
  }

  // Function to update a rating for a specific item from a specific user,
  // if that rating already exists
  Future updateExistingRating(String rateId, num rating) async {
    try {
      await _firestore
          .collection(ratingsCollection)
          .document(rateId)
          .updateData({"rating": rating, "timestamp": Timestamp.now()});
      return true;
    } catch (e) {
      print("Error in updateExistingRating(): " + e.toString());
      return null;
    }
  }

  // Function that creates a rating document for menuItem
  // and adds it to the ratings collection
  Future writeRating(
      String uid, String restId, String itemId, num rating) async {
    try {
      _firestore.collection("ratings").add({
        "restaurantId": restId,
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
