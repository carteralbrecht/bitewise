import 'package:flutter/material.dart';
import 'package:bitewise/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitewise/global.dart' as global;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

  void doSignOut() async {
    var user = await _auth.signOut();

    global.user = user;

    // pop current profile page off of nav stack and push sign in page on
    Navigator.popAndPushNamed(context, '/signin');
  }

  void doDelete() async {
    var user = await _auth.deleteAccount();
    user = null;
    global.user = user;

    Navigator.popAndPushNamed(context, '/signin');
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
              height: 35,
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
              )),
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              // Text(currentUser == null ? "loading.." : currentUser.toString(), style: TextStyle(color: Colors.black, fontSize: 20)),
              FlatButton(
                onPressed: () async => {doSignOut()},
                child: Text("Sign out"),
                height: 40,
                color: Colors.white,
                textColor: Colors.black,
              ),
              FlatButton(
                onPressed: () async => {doDelete()},
                child: Text("Delete"),
                height: 40,
                color: Colors.white,
                textColor: Colors.black,
              ),
              FlatButton(
                onPressed: () async => {
                  if (global.user == null)
                  {
                    print('Woah woah woah cant do that if youre not logged in!')
                  }
                  else
                  {
                    Navigator.pushNamed(context, '/prevRatedItemsPage')
                  }
                },
                child: Text("Rating History"),
                height: 40,
                color: Colors.white,
                textColor: Colors.black,
              ),
            ],
          )),
    );
  }
}
