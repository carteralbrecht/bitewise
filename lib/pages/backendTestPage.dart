import 'package:bitewise/services/geoquery.dart';
import 'package:bitewise/services/ratings.dart';
import 'package:bitewise/services/fsmanager.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  //Text Field State
  String field1 = '';
  num field2 = 0;

  final RatingManager _rateMan = RatingManager();
  final GeoQueryManager _geoQueryManager = GeoQueryManager();
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
                        } else {
                          field2 = 5;
                        }
                      });
                    },
                    decoration: InputDecoration(hintText: 'field 2'),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      _fsm.leaveRating(field1, field2);
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
                      // put function here
                    },
                    child: Text(
                      'Test 2',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      _fsm.createUserInfo(field1);
                    },
                    child: Text(
                      'Test 3',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                ],
              ),
            )));
  }
}
