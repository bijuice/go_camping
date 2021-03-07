import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SmallLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      size: 30,
      color: Colors.blue,
    );
  }
}
