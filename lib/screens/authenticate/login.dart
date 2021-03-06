import 'package:flutter/material.dart';
import 'package:go_camping/services/auth.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationService _auth = AuthenticationService();

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: ElevatedButton(
          child: Text('Log In'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();

            if (result == null) {
              print('error signing in');
            } else {
              print('success!');
              print(result.uid);
            }
          },
        ),
      ),
    );
  }
}
