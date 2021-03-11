import 'package:flutter/material.dart';
import 'package:go_camping/screens/authenticate/signup.dart';
import 'package:go_camping/services/auth.dart';
import 'package:go_camping/widgets/small_loading.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  //loading check
  bool loading = false;

  //text string state
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();

  void goToSignUp(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[300],
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
                      'Log In To',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
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
                        val.isEmpty ? 'Enter an email address' : null,
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
                      setState(() {
                        password = val;
                      });
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
                                      await _auth.logInWithEmailAndPassword(
                                          email, password);

                                  //error checking
                                  if (result == null) {
                                    setState(() => error = 'failed to sign in');
                                    print(error);
                                  } else if (result == 'email') {
                                    setState(
                                        () => error = 'no such email exists');
                                    return NoEmail();
                                  } else if (result == 'password') {
                                    setState(
                                        () => error = 'no such email exists');
                                    return IncorrectPassword();
                                  }
                                }
                              },
                              child: Text('Log In'),
                            )
                    ],
                  ),
                  AspectRatio(aspectRatio: 3),
                  Text('Already have an account?'),
                  TextButton(
                      onPressed: () => goToSignUp(context),
                      child: Text('Sign Up')),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
            )));
  }
}

class NoEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text('Incorrect email or password'),
    );
  }
}

class IncorrectPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text('No such email exists.'),
    );
  }
}
