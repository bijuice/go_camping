import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_camping/initialization/loading.dart';
import 'package:go_camping/initialization/somethingwrong.dart';
import 'package:go_camping/services/auth.dart';
import 'package:go_camping/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:go_camping/models/customuser.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      print(e.toString());
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Loading();
    }
    //firebase instance
    final AuthenticationService _auth = AuthenticationService();
    return StreamProvider<CustomUser>(
      initialData: null,
      create: (_) => _auth.onAuthChange(),
      child: MaterialApp(home: Wrapper()),
    );
  }
}
