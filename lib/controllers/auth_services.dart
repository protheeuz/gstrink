import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'password terlalu lemah') {
        Fluttertoast.showToast(msg: 'Password terlalu lemah');
      } else if (e.code == 'email sudah digunakan.') {
        Fluttertoast.showToast(msg: 'Email sudah digunakan.');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'Email atau Password tidak valid');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Email sudah digunakan.');
      }
    }
    return null;
  }

  
}
