
import 'package:bitewise/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:bitewise/global.dart' as global;
import 'package:flushbar/flushbar.dart';

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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: global.mainColor, width: 2)),
      elevation: 20,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      content: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: TextFormField(
          style: TextStyle(
            fontSize: 20,
          ),
          onChanged: (val) {
            setState(() {
              forgotPassEmail = val;
            });
          },
          decoration: InputDecoration(
            hintText: 'email',
            hintStyle: TextStyle(
              fontSize: 20,
              color: global.accentGrayDark
            ),
          ),
        ),
      ),
      // buttonPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            print("Close dialog??");
          },
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 5, top: 10, bottom: 5),
            child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: global.mainColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            print(forgotPassEmail);
            dynamic result = await _auth.resetPassword(forgotPassEmail);
            if (result == null) {
              print('password reset email sent!');
              Navigator.pop(context);
            } else {
              print(result);
            }
          },
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 5, top: 10, bottom: 5),
            child: Text("Submit", style: TextStyle(color: Colors.black, fontSize: 15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: global.mainColor,
            ),
          ),
        ),
        
      ],
    );


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
                      decoration: InputDecoration(
                        hintText: 'password',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: global.accentGrayDark
                        ),
                      ),
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: () async {
                      print(email);
                      print(password);
                      dynamic result =
                          await _auth.signInByEmail(email, password);
                      if (result == null) {
                        print('error signing in');
                        Flushbar(
                          message: "Username and Password Combination Incorrect",
                          duration:  Duration(seconds: 3),
                        )..show(context);
                      } else {
                        global.user = result;
                        print('signed in');
                        print(result);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 30, bottom: 30),
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 40),
                      decoration: BoxDecoration(
                        border: Border.all(color: global.mainColor),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: global.mainColor,
                      ),
                      child: Text("Sign in", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ),
                  SignInButton(
                    Buttons.Google,
                    elevation:0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: global.mainColor, width: 2)),
                    onPressed: () async {
                      dynamic result = await _auth.signInByGoogle();
                      if (result == null) {
                        print('error signing in by google!');
                        Flushbar(
                          message: "Error signing in by Google",
                          duration:  Duration(seconds: 3),
                        )..show(context);
                      } else {
                        global.user = result;
                        print('signed in');
                        print(result);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(bottom: 30),
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
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'Don\'t have a bitewise account? ', style: TextStyle(color: Colors.black, fontSize: 15)),
                      TextSpan(
                        text: 'Create one here',
                        style: TextStyle(color: Colors.blue, fontSize: 15, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.popAndPushNamed(context, '/register');
                          }
                      ),
                    ],
                  ),
                )
              ]
            )
          ),
        ],
      ),
    );
  }
}


// Container(
//   margin: EdgeInsetsDirectional.only(bottom: 20),
//   child: Column(
//     children: <Widget>[
//       RichText(
//         text: TextSpan(
//           children: <TextSpan>[
//             TextSpan(text: 'Forgot your Password? ', style: TextStyle(color: Colors.black, fontSize: 15)),
//             TextSpan(
//               text: 'Reset password',
//               style: TextStyle(color: Colors.blue, fontSize: 15, decoration: TextDecoration.underline),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () async {
//                   showDialog(
//                     context: context,
//                     builder: (_) => forgotPassModal,
//                     barrierDismissible: true);
//                 }
//             ),
//           ],
//         ),
//       ),
//       RichText(
//         text: TextSpan(
//           children: <TextSpan>[
//             TextSpan(text: 'Don\'t have a bitewise account? ', style: TextStyle(color: Colors.black, fontSize: 15)),
//             TextSpan(
//               text: 'Create one here',
//               style: TextStyle(color: Colors.blue, fontSize: 15, decoration: TextDecoration.underline),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   Navigator.pushNamed(context, '/register');
//                 }
//             ),
//           ],
//         ),
//       )
//     ]
//   )
// ),

// onPressed: () async {
//   dynamic result = await _auth.signInByGoogle();
//   if (result == null) {
//     print('error signing in by google!');
//   } else {
//     global.user = result;
//     print('signed in');
//     print(result);
//     Navigator.pop(context);
//   }
// },

// onPressed: () async {
//   print(email);
//   print(password);
//   dynamic result =
//       await _auth.signInByEmail(email, password);
//   if (result == null) {
//     print('error signing in');
//   } else {
//     global.user = result;
//     print('signed in');
//     print(result);
//     Navigator.pop(context);
//   }
// },