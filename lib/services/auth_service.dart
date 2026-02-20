import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/sign_in_page/sign_in_page.dart';
import 'package:instagram_clone/services/prefs.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signInUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User user = _auth.currentUser!;
      debugPrint(user.toString());
      return user;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<User?> signUpUser(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = authResult.user!;
      return user;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static void signOut(BuildContext context) async {
    await _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    });
  }
}
