import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  //Text Field State
  String field1 = '';
  String field2 = '';

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        title: Text('Test', style: TextStyle(color: Colors.black,  ),),
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
                decoration: InputDecoration(
                  hintText: 'field 1'
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    field2 = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'field 2'
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async {
                  // Put function here
                },
                child: Text('Test 1',  style: TextStyle(color: Colors.black, fontSize: 20),),
                color: Colors.yellow[600],
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async {
                  // put function here
                },
                child: Text('Test 2',  style: TextStyle(color: Colors.black, fontSize: 20),),
                color: Colors.yellow[600],
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async {
                  // put function here
                },
                child: Text('Test 3',  style: TextStyle(color: Colors.black, fontSize: 20),),
                color: Colors.yellow[600],
              ),
              
            ],
          ),
        )
      )
    );
  }
}
