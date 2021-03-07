import 'package:flutter/material.dart';
import 'package:go_camping/screens/authenticate/login.dart';
import 'package:go_camping/services/auth.dart';
import 'package:go_camping/widgets/small_loading.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();

  void goToLogIn(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lime[300],
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Spacer(
                    flex: 4,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign Up To',
                      style: TextStyle(
                          color: Colors.blue, fontSize: 20, letterSpacing: 2),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Go Camping!',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 45,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), labelText: 'Email'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter a valid email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password', icon: Icon(Icons.vpn_key_sharp)),
                    validator: (val) => val.length < 8
                        ? 'Password must be at least 8 characters long'
                        : null,
                    onChanged: (val) {
                      password = val;
                    },
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      loading == true
                          ? SmallLoading()
                          : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() => error = 'failed to sign up');
                                    print(error);
                                  } else if (result == 'used') {
                                    setState(
                                        () => error = 'email already exists');
                                    return EmailExists();
                                  }
                                }
                              },
                              child: Text('Sign Up'),
                            )
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
            )));
  }
}

class EmailExists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SnackBar(content: Text('Email has already been registered before'));
  }
}
