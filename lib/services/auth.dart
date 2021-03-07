import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_camping/models/customuser.dart';

class AuthenticationService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on Firebase
  CustomUser _userFromFirebase(User user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  //on auth user stream
  Stream<CustomUser> onAuthChange() {
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

  //register with email and password

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak';
      } else if (e.code == 'email-already-in-use') {
        return 'used';
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password

  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'email';
      } else if (e.code == 'wrong-password') {
        return 'password';
      }
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
