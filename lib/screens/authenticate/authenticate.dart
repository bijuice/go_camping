import 'package:flutter/material.dart';
import 'package:go_camping/screens/authenticate/login.dart';
import 'package:go_camping/screens/authenticate/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    bool showLogIn = true;

    //TODO: implement login/signup switching
    //TODO: implement password hashing

    if (showLogIn) {
      return LogIn();
    } else {
      return SignUp();
    }
  }
}
