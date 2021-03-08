import 'package:bitewise/services/auth.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  //Text Field State
  String field1 = '';
  num field2 = 0;

  final AuthService _authServ = AuthService();
  final FirestoreManager _fsm = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.yellow[600],
          title: Text(
            'Test',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        field1 = val;
                      });
                    },
                    decoration: InputDecoration(hintText: 'field 1'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        // temp way to make field2 a num
                        // The form field will be diff in the rating modal
                        // so this part doesnt need to be big brained
                        if (val == '1') {
                          field2 = 1;
                        } else if (val == '2') {
                          field2 = 2;
                        } else if (val == '3') {
                          field2 = 3;
                        } else if (val == '4') {
                          field2 = 4;
                        } else if (val == '5') {
                          field2 = 5;
                        } else {
                          field2 = 0;
                        }
                      });
                    },
                    decoration: InputDecoration(hintText: 'field 2'),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      _fsm.leaveRating("BackendTestRestaurant", field1, field2);
                    },
                    child: Text(
                      'Test 1',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      print("---- calling getTopFive -------");
                      List<dynamic> res = await _fsm.getTopFiveItemsAtRestaurant(field1);
                      print("TOP 5 FOR " + field1 + ": ");
                      print(res);
                      print("attempting res[i][''itemId'']");
                      for (var i = 0; i < 5; i++) print(res[i]["itemId"]);
                    },
                    child: Text(
                      'getTop5 test',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      print("---- calling getTopN -------");
                      dynamic res = await _fsm.getTopNItemsAtRestaurant(field1, field2);
                      print("TOP N FOR " + field1 + ": ");
                      print(res);
                    },
                    child: Text(
                      'getTopN test',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      dynamic res = await _fsm.getDocData(
                          _fsm.menuItemCollection, field1, "avgRating");
                      print("Avg rating for " + field1 + " is:");
                      print(res);
                    },
                    child: Text(
                      'Get Avg Rating',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      FirebaseUser user = await _authServ.getUser();
                      _fsm.getUserRating(user.uid, field1);
                      dynamic res = await _fsm.getDocData(
                          _fsm.menuItemCollection, field1, "avgRating");
                      print("Users rating for ");
                      print(user.uid);
                      print("is ");
                      print(res);
                    },
                    child: Text(
                      'Get Users Rating',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                ],
              ),
            )));
  }
}
