// Conection to Firebase and Authorization Logic Here
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    hostedDomain: "",
    clientId: "",
  );

  // Gets the current signed in user
  // test comment
  Future getUser() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      return user;
    } catch (e) {
      print("err in getUser()");
      print(e.toString());
      return null;
    }
  }

  Future registerByEmail(String email, String password) async {
    try {
      AuthResult res = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = res.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInByEmail(String email, String password) async {
    try {
      AuthResult res = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = res.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInByGoogle() async {
    try {
      dynamic user = await getUser();
      if (user != null) {
        print(user);
        print(
            "already signed in to an account. Please sign out before logging into a new account.");
        return user;
      }

      // this sign out is just to ensure the prompt will show up
      _googleSignIn.signOut();

      // prompt the user to sign into their google account
      print("prompt for gAcc");
      GoogleSignInAccount gAcc = await _googleSignIn.signIn();
      print("gAcc chosen");

      // create the credential for the google account
      GoogleSignInAuthentication gAuth = await gAcc.authentication;
      AuthCredential gCred = GoogleAuthProvider.getCredential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      // Create the firebase user with the google account credential
      user = (await _auth.signInWithCredential(gCred)).user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      _googleSignIn.signOut();
      _auth.signOut();
      return null;
    } catch (e) {
      print(e.toString());
      return _auth.currentUser();
    }
  }

  Future deleteAccount() async {
    try {
      FirebaseUser user = await getUser();
      user.delete();
      return 0;
    } catch (e) {
      print("err in deleteAccount()");
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      print("err in resetPassword()");
      print(e.toString());
      return e.toString();
    }
  }

  // Feature to sign in a user upon app load.
  // (currently unused)
  Future signInOnLoad() async {
    try {
      FirebaseUser check = await getUser();
      if (check == null) {
        // If there is no account on this device, creates an anon account.
        print('User DNE for this device, creating anon');
        AuthResult result = await _auth.signInAnonymously();
        FirebaseUser user = result.user;
        return user;
      } else {
        // Account already logged in on this device.
        print('User is signed in!');
        return check;
      }
    } catch (e) {
      print("err in signInOnAppLoad: " + e.toString());
      return null;
    }
  }

  // Gets credentials for an email/password account
  // (currently unused)
  Future getCredential(String email, String password) async {
    try {
      AuthCredential res =
          EmailAuthProvider.getCredential(email: email, password: password);
      return res;
    } catch (e) {
      // we should probably have some UI pop up that gives the user the reason
      // for why they cant make this account
      print(e.toString());
      return null;
    }
  }

  // Future to upgrade a user's anon account to an email/password account
  // (currently unused)
  Future anonToEmail(FirebaseUser user, String email, String password) async {
    try {
      // Check if user is already linked to a non anon account
      if (user.isAnonymous == false) {
        print("User has a registered account");
        return user;
      }
      // Create account credentials w/ email + password, link to the anon user
      AuthCredential cred = await getCredential(email, password);
      if (cred == null) {
        print("Could not generate credential with email: " +
            email +
            " and password: " +
            password);
      }
      user.linkWithCredential(cred);
      return user;
    } catch (e) {
      print(e.toString());
      return user;
    }
  }
}
