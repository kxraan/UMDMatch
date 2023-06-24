

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lib/screens/authentication/sign_in.dart';
import '../../Models/user.dart';


class AuthService {
  final FirebaseAuth _authen = FirebaseAuth.instance;

  user_data?  _userFromFirebaseUser(User? user) {
    return user != null ? user_data(name: user.uid) : null;
  }
  //auth change user stream
  Stream<user_data?> get user {
    return _authen.authStateChanges().map(_userFromFirebaseUser!);//(User? customer) => _userFromFirebaseUser(user!)
  }

  signInWithGoogle({required BuildContext context}) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User? user;
    // Once signed in, return the UserCredential
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      user = userCredential.user;
      //print(user!.email);
      if(user!.email!.endsWith('terpmail.umd.edu')){
        //print(user.email);
      }else{
        await GoogleSignIn().disconnect();
        FirebaseAuth.instance.currentUser!.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content:
            'Please your Terpmail account',
          ),
        );
      }
      //return userCredential;
    }on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content:
            'The account already exists with a different credential',
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content:
            'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AuthService.customSnackBar(
          content: 'Error occurred using Google Sign In. Try again.',
        ),
      );
    }

  }

  //sign out
  Future signout() async {
    try{
      /*TODO clear googole cache when signing out*/
      await GoogleSignIn().disconnect();
       await _authen.signOut();
       return SignIn();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      duration: Duration(seconds: 10),
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

}