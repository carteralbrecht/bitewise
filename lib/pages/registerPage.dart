import 'package:bitewise/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:bitewise/global.dart' as global;
import 'package:flushbar/flushbar.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Text Field State
  String email = '';
  String password = '';
  String confPassword = '';

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.clear, color: Colors.black, size: 30),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Image(image: AssetImage('assets/Bitewise_logo-Black.png')),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) => RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
                        ).hasMatch(input) ? 'null' : 'Invalid email format',
                      decoration: InputDecoration(
                        hintText: 'email',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: global.accentGrayDark
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical:10),
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) => input != null && input.length < 6 ? 'Password must be length 6 or greater' : null,
                      decoration: InputDecoration(
                        hintText: 'password',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: global.accentGrayDark
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          confPassword = val;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) => input == password ? null : 'Passwords must match',
                      decoration: InputDecoration(
                        hintText: 'confirm password',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: global.accentGrayDark
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                        // Get current account, and upgrade it to an email/pass account
                      if (password != confPassword || password.length < 6 || !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(email)) {
                        Flushbar(
                          message: "Fix errors before registering",
                          duration:  Duration(seconds: 3),
                        )..show(context);
                      }
                      else {
                        dynamic result = await _auth.registerByEmail(email, password);
                        if (result == null) {
                          print('error registering');
                          Flushbar(
                            message: "Error Registering",
                            duration:  Duration(seconds: 3),
                          )..show(context);
                        } else {
                          global.user = result;
                          print('registered');
                          print(result);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 40),
                      decoration: BoxDecoration(
                        border: Border.all(color: global.mainColor),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: global.mainColor,
                      ),
                      child: Text("Register", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 40),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Already have a Bitewise account? ', style: TextStyle(color: global.accentGrayDark, fontSize: 15)),
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(color: Colors.blue, fontSize: 15, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.popAndPushNamed(context, '/signin');
                      }
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}


// Container(
//   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
//   child: Form(
//     child: Column(
//       children: <Widget>[
//         SizedBox(height: 20),
//         TextFormField(
//           onChanged: (val) {
//             setState(() {
//               email = val;
//             });
//           },
//           decoration: InputDecoration(hintText: 'email'),
//         ),
//         SizedBox(height: 20),
//         TextFormField(
//           obscureText: true,
//           onChanged: (val) {
//             setState(() {
//               password = val;
//             });
//           },
//           decoration: InputDecoration(hintText: 'password'),
//         ),
//         SizedBox(height: 20),
//         TextFormField(
//           obscureText: true,
//           onChanged: (val) {
//             setState(() {
//               password = val;
//             });
//           },
//           decoration: InputDecoration(hintText: 'confirm password'),
//         ),
//         SizedBox(height: 20),
//         RaisedButton(
//           onPressed: () async {
//             print(email);
//             print(password);
//             // Get current account, and upgrade it to an email/pass account
//             dynamic result =
//                 await _auth.registerByEmail(email, password);
//             if (result == null) {
//               print('error registering');
//             } else {
//               global.user = result;
//               print('registered');
//               print(result);
//               Navigator.popUntil(context, ModalRoute.withName('/'));
//             }
//           },
//           child: Text(
//             'Register',
//             style: TextStyle(color: Colors.black, fontSize: 20),
//           ),
//           color: Colors.yellow[600],
//         ),
//       ],
//     ),
//   )
// )
