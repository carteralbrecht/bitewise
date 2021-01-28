import 'package:flutter/material.dart';
import 'package:bitewise/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  FirebaseUser currentUser;

  @override
  void initState()  {
    getCurrentUser();
    super.initState();
  }

  void doSignOut() async {
    var user = await _auth.signOut();

    setState(() {
      currentUser = user;
    });

    Navigator.pushNamed(context, '/signin');

  }

  Future getCurrentUser() async {
    FirebaseUser user = await _auth.getUser();
    print("setting state: ");
    print(user.toString());
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[300],
      appBar: AppBar(
          backgroundColor: Colors.yellow[600],
          title: Text(
            "Profile Page",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          centerTitle: true,
          actions: <Widget>[
              Container(
                height:35,
                width: 35,
                // decoration: new BoxDecoration(
                //   color: Colors.white,
                //   shape: BoxShape.circle,
                // ),
                margin: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    print("Settings");
                    
                  },
                  child: Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                )
              ),
            ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(currentUser == null ? "loading.." : currentUser.toString(), style: TextStyle(color: Colors.black, fontSize: 20)),
            FlatButton(
              onPressed:  () async => {
                doSignOut()
              }, 
              child: Text("Sign out"),
              height: 40,
              color: Colors.white,
              textColor: Colors.black,
            ),
          ],
        )
      ),
    );
  }
}