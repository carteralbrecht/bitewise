import 'package:bitewise/models/menuItem.dart';
import 'package:bitewise/services/auth.dart';
import 'package:bitewise/services/documenu.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemListUtil {

  static Future<List<Future<MenuItem>>> getPreviouslyRatedItems() async {

    FirebaseUser currentUser = await AuthService().getUser();

    if (currentUser == null)
      return null;

    FirestoreManager fsm = FirestoreManager();

    dynamic itemIds = await fsm.getDocData(fsm.userCollection, currentUser.uid, "ratedItems");

    List<Future<MenuItem>> itemsToReturn = new List();

    if (itemIds != null) { 
      for (String itemId in itemIds) {
        var item = Documenu.getMenuItem(itemId);
        itemsToReturn.add(item);
      }
    }

    return itemsToReturn;
  }

}