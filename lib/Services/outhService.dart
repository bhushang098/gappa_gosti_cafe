import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password, BuildContext context);

  Future<String> signUp(String email, String password, BuildContext context);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<String> signInAnon();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<FirebaseUser> get user {
    return _firebaseAuth.onAuthStateChanged;
  }

  Future<String> signIn(
      String email, String password, BuildContext context) async {
    FirebaseUser user;
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address is not valid";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "This Mail Already Used By another Account";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.

            content: Text(errorMessage),
          );
        },
      );
    }
    return user.uid;
  }

  Future<String> signUp(
      String email, String password, BuildContext context) async {
    FirebaseUser user;
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address is not valid";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "This Mail Already Used By another Account";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      print('My error Is This ><><><>M<><><M><><><><><< ${e.toString()}');
    }
    if (errorMessage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            content: Text(errorMessage),
          );
        },
      );
    }
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<String> signInAnon() async {
    AuthResult user = await _firebaseAuth.signInAnonymously();
    return user.user.uid.toString();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
