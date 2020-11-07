// Conection to Firebase and Authorization Logic Here
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future registerByEmail(String email, String password) async {
    try {
      AuthResult res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      FirebaseUser user = res.user;
      return user;
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  Future signInByEmail(String email, String password) async {
    try {
      AuthResult res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      FirebaseUser user = res.user;
      return user;
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      _auth.signOut();
      return null;
    }
    catch(e)
    {
      print(e.toString());
      return _auth.currentUser();
    }
  }


}

