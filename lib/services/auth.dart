import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_camping/models/customuser.dart';

class AuthenticationService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on Firebase
  CustomUser _userFromFirebase(User user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  //on auth user stream
  Stream<CustomUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  //sign in anonymously
  Future<CustomUser> signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Could not sign out');
      print(e.toString());
    }
  }
}
