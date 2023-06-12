import 'package:firebase_auth/firebase_auth.dart';
import 'package:umddating/Models/user.dart';
import 'package:umddating/services/database.dart';

import '../Models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FbUser?  _userFromFirebaseUser(User? user) {
    return user != null ? FbUser(name: user.uid) : null;
  }
  //auth change user stream
  Stream<FbUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser!);//(User? customer) => _userFromFirebaseUser(user!)
  }

  //signing in with email and password
  Future signIn(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);

    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  //register with email and password
  Future register(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
    //  DatabaseService({uid: user!.uid}).updateUserData("v", "4", "m", "f");
      return _userFromFirebaseUser(user);

    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signout() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }


}