import 'package:flutter/material.dart';
import 'package:go_camping/services/auth.dart';

class Home extends StatelessWidget {
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Sign Out'),
          onPressed: () {
            _auth.signOut();
          },
        ),
      ),
    );
  }
}
