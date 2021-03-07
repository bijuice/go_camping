import 'package:flutter/material.dart';
import 'package:go_camping/models/customuser.dart';
import 'package:go_camping/screens/authenticate/login.dart';
import 'package:go_camping/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<CustomUser>();

    if (user == null) {
      return LogIn();
    } else {
      return Home();
    }
  }
}
