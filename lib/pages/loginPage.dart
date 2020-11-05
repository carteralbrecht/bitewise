import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  //Text Field State
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        title: Text('Sign Up', style: TextStyle(color: Colors.black,  ),),
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
                    username = val;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async {
                  print(username);
                  print(password);
                  // Connection to Firebase Here
                },
                child: Text('Sign Up',  style: TextStyle(color: Colors.black, fontSize: 20),),
                color: Colors.yellow[600],
              )
            ],
          ),
        )
      )
    );
  }
}
