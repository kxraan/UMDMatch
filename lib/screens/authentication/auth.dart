import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Models/user.dart';


class AuthService {
  final FirebaseAuth _authen = FirebaseAuth.instance;
  FbUser?  _userFromFirebaseUser(User? user) {
    return user != null ? FbUser(name: user.uid) : null;
  }
  //auth change user stream
  Stream<FbUser?> get user {
    return _authen.authStateChanges().map(_userFromFirebaseUser!);//(User? customer) => _userFromFirebaseUser(user!)
  }

  //signing in with email and password
  Future signIn(String email, String password) async {
    try{
      UserCredential result = await _authen.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);

    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  //register with email and password
  Future signUp(String email, String password, BuildContext context) async {
    try{
      UserCredential result = await _authen.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
    //  DatabaseService({uid: user!.uid}).updateUserData("v", "4", "m", "f");
      return _userFromFirebaseUser(user);

    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
      }
      return null;
    }
    catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }
/*  static Future<User?> sign_up(
      {required String userEmail,
        required String password,
        required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }*/

  //sign out
  Future signout() async {
    try{
      return await _authen.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }


}