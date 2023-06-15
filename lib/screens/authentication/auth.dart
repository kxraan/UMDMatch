

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
 /* var acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');*/
  
  //signing in with email and password
  /*Future logIn(String email) async {
    
    try{
      await _authen.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
    *//*  UserCredential result =
      User? user = result.user;
      return _userFromFirebaseUser(user);*//*
    }catch(e) {
      print(e.toString());
      return null;
    }
  }*/

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
      print(user!.email);
      if(user!.email!.endsWith('terpmail.umd.edu')){
        print(user.email);
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

  //register with email and password
  /*Future signUp(String email, String password, BuildContext context) async {
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
      } else{
        print(e.toString());
      }
      return null;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }*/
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
      /*TODO clear googole cache when signing out*/
      return await _authen.signOut();
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