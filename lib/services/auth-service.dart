import 'dart:async';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth/services/service.dart';

class AuthService implements Service {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /*factory AuthService() {
    return AuthService.internal;
  }
  AuthService.nternal;
  */

  // this code can be rewritten by just returning the future from signin with
  // email and password
  Future<String> signIn(String email, String password) async {
    var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() {
    return _firebaseAuth.currentUser();
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
