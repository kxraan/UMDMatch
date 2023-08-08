import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lib/screens/authentication/register.dart';
import 'package:lib/screens/authentication/sign_in.dart';
import 'package:lib/screens/header.dart';
import 'package:provider/provider.dart';

import '../Home/home.dart';
import '../Models/user.dart';
import 'authentication/signOut.dart';
import 'custombottomnavigationbar.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  Future<bool> check_register() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;

    try {
      var pref = await FirebaseFirestore.instance.collection('users').doc(
          userId).collection('profile').doc('required').get();
      return pref.exists;
    }catch (error){
      print('in error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context)  {

    final user = Provider.of<user_data?>(context);

    if(user == null) {
      return SignIn();
    } else {
      if(FirebaseAuth.instance.currentUser!.email!.endsWith('terpmail.umd.edu')){
        AsyncSnapshot<bool> flag;
       return FutureBuilder<bool>(
           future: check_register(),
           builder:(context, flag) {
             if (flag.hasData) {
               if (flag.data == true) {
                 return NavBar()  ;//Home()
               } else {
                 return Register();
               }
             }else{
               /*TODO
                    Create a laoding page !!!!
                */
               return CircularProgressIndicator();

             }
           });

      }else{
        FirebaseAuth.instance.currentUser!.delete();
        return SignIn();
      }
    }

  }
}
