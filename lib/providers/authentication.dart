import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<String> signIn(
      String email, String password, BuildContext context) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context, rootNavigator: true).pop();
      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return "Your email address appears to be malformed.";

        case "wrong-password":
          return "Your password is wrong.";

        case "user-not-found":
          return "User with this email doesn't exist.";

        case "user-disabled":
          return "User with this email has been disabled.";

        default:
          return "An undefined Error happened.";
      }
    } catch (e) {
      return "An Error occur";
    }
  }

  Future<String> signUp(
      String email, String password, String name, BuildContext context,String role) async {
    try {
      _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          Navigator.of(context, rootNavigator: true).pop();

          FirebaseFirestore.instance
              .collection("users")
              .doc(value.user!.uid)
              .set(
            {
              "name": name,
              "email": value.user!.email,
              "url": "",
              "role": role,
              "phone" : "+880"
            },
          );
        },
      );

      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "weak-password":
          return "Your password is too weak";

        case "invalid-email":
          return "Your email is invalid";

        case "email-already-in-use":
          return "Email is already in use on different account";

        default:
          return "An undefined Error happened.";
      }
    } catch (e) {
      return "An Error occur";
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  Future deleteUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.delete();
      FirebaseFirestore.instance.collection("users").doc(user.uid).delete();
    }
  }
}
