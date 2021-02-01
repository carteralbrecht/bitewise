
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:bitewise/global.dart' as global;

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Text Field State
  String email = '';
  String password = '';
  String forgotPassEmail = '';

  final AuthService _auth = AuthService();

  

  @override
  Widget build(BuildContext context) {

    AlertDialog forgotPassModal = AlertDialog(
      title: Container(alignment: Alignment.center, child:Text("Reset Password"), margin: EdgeInsets.only(bottom: 10)),
      titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
      titlePadding: EdgeInsets.only(left: 20, top: 15, bottom: 0, right: 20),
      backgroundColor: Colors.yellow[600],
      elevation: 20,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      content: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: TextFormField(
          style: TextStyle(fontSize: 20),
          onChanged: (val) {
            setState(() {
              forgotPassEmail = val;
            });
          },
          decoration: InputDecoration(
            hintText: 'email',
            hintStyle: TextStyle(fontSize: 20),
            border: InputBorder.none,
          ),
        ),
      ),
      // buttonPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      actions: [
        FlatButton(
          color: Colors.yellow[300],
          child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 15)),
          onPressed: () {
            Navigator.pop(context);
            print("Close dialog??");
          },
        ),
        FlatButton(
          color: Colors.yellow[300],
          child: Text("Submit", style: TextStyle(color: Colors.black, fontSize: 15)),
          onPressed: () async {
            print(forgotPassEmail);
            dynamic result = await _auth.resetPassword(forgotPassEmail);
            if (result == null) {
              print('password reset email sent!');
              Navigator.pop(context);
            } else {
              print(result);
            }
          },
        ),
      ],
    );


    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.yellow[600],
          title: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsetsDirectional.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.fastfood_rounded, size: 75),
                    Text("bitewise", style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold)),
                  ]
                )
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.yellow[600]),
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'email',
                            hintStyle: TextStyle(fontSize: 20),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'password',
                            hintStyle: TextStyle(fontSize: 20),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        onPressed: () async {
                          print(email);
                          print(password);
                          dynamic result =
                              await _auth.signInByEmail(email, password);
                          if (result == null) {
                            print('error signing in');
                          } else {
                            global.user = result;
                            print('signed in');
                            print(result);
                            Navigator.popUntil(context, ModalRoute.withName('/'));
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        color: Colors.yellow[300],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        onPressed: () async {
                          dynamic result = await _auth.signInByGoogle();
                          if (result == null) {
                            print('error signing in by google!');
                          } else {
                            global.user = result;
                            print('signed in');
                            print(result);
                            Navigator.popUntil(context, ModalRoute.withName('/'));
                          }
                        },
                        child: Text(
                          'Continue with Google',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        onPressed: () async {
                          // dynamic result = await _auth.signInByGoogle();
                          // if (result == null) {
                          //   print('error signing in by google!');
                          // } else {
                          //   print('signed in');
                          //   print(result);
                          // }
                        },
                        child: Text(
                          'Continue with Facebook',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.blue[800],
                      ),
                    ],
                  )
                )
              ),
              Container(
                margin: EdgeInsetsDirectional.only(bottom: 20),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Forgot your Password? ', style: TextStyle(color: Colors.black, fontSize: 15)),
                          TextSpan(
                            text: 'Reset password',
                            style: TextStyle(color: Colors.blue, fontSize: 15, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                showDialog(
                                  context: context,
                                  builder: (_) => forgotPassModal,
                                  barrierDismissible: true);
                              }
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Don\'t have a bitewise account? ', style: TextStyle(color: Colors.black, fontSize: 15)),
                          TextSpan(
                            text: 'Create one here',
                            style: TextStyle(color: Colors.blue, fontSize: 15, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/register');
                              }
                          ),
                        ],
                      ),
                    )
                  ]
                )
              ),
            ]
          )
        );
  }
}
