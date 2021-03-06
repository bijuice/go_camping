import 'package:flutter/material.dart';
import 'package:go_camping/models/customuser.dart';
import 'package:go_camping/screens/authenticate/login.dart';
import 'package:go_camping/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);

    return MaterialApp(home: user == null ? LogIn() : Home());
  }
}
