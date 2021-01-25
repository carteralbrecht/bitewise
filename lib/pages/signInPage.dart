import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
            'Sign In',
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
                  RaisedButton(
                    onPressed: () async {
                      print(email);
                      print(password);
                      dynamic result =
                          await _auth.signInByEmail(email, password);
                      if (result == null) {
                        print('error signing in');
                      } else {
                        print('signed in');
                        print(result);
                      }
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  RaisedButton(
                    onPressed: () async {
                      dynamic result = await _auth.signInByGoogle();
                      if (result == null) {
                        print('error signing in by google!');
                      } else {
                        print('signed in');
                        print(result);
                      }
                    },
                    child: Text(
                      'Sign In with Google',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Don't have an account? Sign up below!",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      print(email);
                      print(password);
                      dynamic result = await _auth.signOut();
                      if (result == null) {
                        print('signed out succesfully');
                      } else {
                        print(result);
                      }
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () async {
                      print(email);
                      print(password);
                      dynamic result = await _auth.deleteAccount();
                      if (result == 0) {
                        print('account deleted succesfully');
                      } else {
                        print(result);
                      }
                    },
                    child: Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.yellow[600],
                  ),
                ],
              ),
            )));
  }
}
