import 'package:bitewise/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bitewise/global.dart' as global;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Text Field State
  String email = '';
  String password = '';

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.yellow[600],
          title: Text(
            'Sign Up',
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
                        email = val;
                      });
                    },
                    decoration: InputDecoration(hintText: 'email'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    decoration: InputDecoration(hintText: 'password'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    decoration: InputDecoration(hintText: 'confirm password'),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      print(email);
                      print(password);
                      // Get current account, and upgrade it to an email/pass account
                      dynamic result =
                          await _auth.registerByEmail(email, password);
                      if (result == null) {
                        print('error registering');
                      } else {
                        global.user = result;
                        print('registered');
                        print(result);
                        Navigator.pushNamed(context, '/');
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                ],
              ),
            )));
  }
}
