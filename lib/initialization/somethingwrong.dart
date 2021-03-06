import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        body: Text(
          'Pardon Us, Something Went Wrong.',
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
