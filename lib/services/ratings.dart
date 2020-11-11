// Conection to Firebase APIs here
import 'package:bitewise/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingManager {
  final AuthService _auth = AuthService();
  final Firestore _firestore = Firestore.instance;

  // Future that creates a rating document for menuItem
  // and adds it to the ratings collection
  Future writeRating(String itemId, num rating, String uid) async {
    try {
      _firestore
          .collection("ratings")
          .add({"menuitemuid": itemId, "rating": rating, "useruid": uid}).then(
              (value) {
        print('rating left for ' + itemId);
        print(value.documentID);
      });
    } catch (e) {
      print('err in writeRating() :');
      print(e.toString());
    }
    return;
  }

  // Future that updates the avgRate and numRate fields of menuItem
  Future updateAvgRating(String itemId, num rating) async {
    // will implement once avgRating + numRatings fields are added to the db

    // get the doc associated w/ itemId
    // take its curr avgRate and curr numRate
    // avgRate = ((avgRate * numRate) +  rating)/(numRate + 1);
    // numRate = numRate + 1;
    // update the doc w/ new avgRate and numRate vals
    return;
  }

  // User tried to rate without being logged in,
  // prompt them to sign up for (or create) an account
  Future promptToSignUp() async {
    // either takes them to a new page or pops up a modal for them to sign up
    print(
        'woah woah woah, hold your horses buddy. If you wanna leave a rating, you gotta sign up for an account. subway eat fresh.');
    return;
  }

  // Future to leave a rating for a menu item
  Future leaveRating(String itemId, num rating) async {
    try {
      FirebaseUser user = await _auth.getUser();
      if (user != null) {
        // If there is a current user, writeRating to the ratings collection
        // and update average rating for the menuitem
        String uid = user.uid;
        writeRating(itemId, rating, uid);
        updateAvgRating(itemId, rating);
      } else {
        // prompt user to sign up if they are not in an authorized account
        promptToSignUp();
      }
    } catch (e) {
      print('err in leaveRating() :');
      print(e.toString());
    }
  }
}
