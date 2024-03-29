import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitewise/services/auth.dart';
import 'package:bitewise/global.dart' as global;
import 'package:flushbar/flushbar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

  String oldPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: global.mainColor,
        title: Text(
          "My Account",
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
          // Container(
          //     height: 35,
          //     width: 35,
          //     // decoration: new BoxDecoration(
          //     //   color: Colors.white,
          //     //   shape: BoxShape.circle,
          //     // ),
          //     margin: EdgeInsets.only(right: 10.0),
          //     child: GestureDetector(
          //       onTap: () {
          //         print("Settings");
          //       },
          //       child: Icon(
          //         Icons.settings,
          //         color: Colors.grey,
          //       ),
          //     )),
        ],
      ),
      body: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              // Text(currentUser == null ? "loading.." : currentUser.toString(), style: TextStyle(color: Colors.black, fontSize: 20)),
              Container(
                alignment: Alignment.topLeft,
                child: Text("Change Password",
                    style: TextStyle(color: Colors.black, fontSize: 22)),
              ),
              Container(
                margin: EdgeInsets.all(7),
                child: TextFormField(
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  onChanged: (val) {
                    setState(() {
                      oldPassword = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'old password',
                    hintStyle:
                        TextStyle(fontSize: 20, color: global.accentGrayDark),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(7),
                child: TextFormField(
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  onChanged: (val) {
                    setState(() {
                      newPassword = val;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (input) => input != null && input.length >= 6 ? null : 'Password must be length 6 or greater',
                  decoration: InputDecoration(
                    hintText: 'new password',
                    hintStyle:
                        TextStyle(fontSize: 20, color: global.accentGrayDark),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(7),
                child: TextFormField(
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  onChanged: (val) {
                    setState(() {
                      confirmNewPassword = val;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (input) => input == newPassword ? null : 'Passwords must match',
                  decoration: InputDecoration(
                    hintText: 'confirm new password',
                    hintStyle:
                        TextStyle(fontSize: 20, color: global.accentGrayDark),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (newPassword == confirmNewPassword) {
                    FirebaseUser user = await _auth.getUser();
                    bool success = await _auth.passwordResetLoggedIn(
                        user.email, oldPassword, newPassword);
                    if (success == true) {
                      Flushbar(
                        message: "Password updated",
                        duration: Duration(seconds: 5),
                      )..show(context);
                    } else {
                      Flushbar(
                        message: "Incorrect password",
                        duration: Duration(seconds: 5),
                      )..show(context);
                    }
                  } else {
                    Flushbar(
                      message: "Passwords must match",
                      duration: Duration(seconds: 5),
                    )..show(context);
                  }
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: global.mainColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: global.mainColor,
                  ),
                  child: Text("Save",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ),
              Divider(thickness: 5, height: 5),
              GestureDetector(
                onTap: () async {
                  Navigator.pushNamed(context, '/prevRatedItemsPage');
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: global.mainColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: global.mainColor,
                  ),
                  child: Text("Rating History",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  doSignOut();
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: global.mainColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: global.mainColor,
                  ),
                  child: Text("Sign out",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  doDelete();
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: global.mainColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: global.mainColor,
                  ),
                  child: Text("Delete account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ),
            ],
          )),
    );
  }
}
