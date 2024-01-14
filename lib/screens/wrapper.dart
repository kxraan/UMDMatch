import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lib/screens/authentication/sign_in.dart';
import 'package:lib/screens/widgets/header.dart';
import 'package:lib/screens/registration/name.dart';
import 'package:lib/screens/widgets/splash.dart';
import 'package:provider/provider.dart';
import '../database/app_user.dart';
import 'home.dart';
import 'authentication/auth.dart';
import 'authentication/signOut.dart';
import 'widgets/nav_bar.dart';

class Wrapper extends StatefulWidget{
  const  Wrapper({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Wrapper();
}

class _Wrapper extends State<Wrapper> {

  late Future<bool> checkRegisterFuture;
  late Future<void> appUserInitializeFuture;

  @override
  void initState() {
    super.initState();

    // Initialize AppUser and check_register futures
    print('is this one?');
    final AppUser appUser = Provider.of<AppUser>(context, listen: false);
    appUserInitializeFuture = appUser.initialize();
    checkRegisterFuture = check_register();
  }


  Future<bool> check_register() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);

    try {
      /*TODO
      * Make it full proof. Only checks for required as of now
      */

      //print(userId);
      var pref = await FirebaseFirestore.instance.collection('users')
          .doc(userId!).collection('profile').doc('images').get();

      return pref.exists;
    }catch (error){
      print(error.toString() + 'in error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context)  {

    final user = Provider.of<user_data?>(context);
   // final AppUser appUser = Provider.of<AppUser>(context, listen: false);


    if(user == null) {
      return SignIn();
    } else {
      if(FirebaseAuth.instance.currentUser!.email!.endsWith('terpmail.umd.edu')){
        AsyncSnapshot<bool> flag;
       return FutureBuilder(
           future: Future.wait([
             checkRegisterFuture, appUserInitializeFuture
           ]),
           builder:(context, AsyncSnapshot<List<dynamic>> snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return SplashScreen(); // Show loading indicator while waiting
             }
             else  {

               if (snapshot.data?[0] == true) {
                 //initialize();
                 return NavBar(); //Home()  ;
               } else {
                 //print("here--------------------------");
                 return Name();
               }
             }
           });

      }else{
        FirebaseAuth.instance.currentUser!.delete();
        return SignIn();
      }
    }

  }


}
