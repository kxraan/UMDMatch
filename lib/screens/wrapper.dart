import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lib/screens/authentication/register.dart';
import 'package:provider/provider.dart';

import '../Home/home.dart';
import '../Models/user.dart';
import 'authentication/authenticate.dart';
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FbUser?>(context);

    if(user == null) {
      return Authenticate();
    } else {
      if(FirebaseAuth.instance.currentUser!.email!.endsWith('terpmail.umd.edu')){
        return Home();
      }else{
        FirebaseAuth.instance.currentUser!.delete();
        return Authenticate();
      }
    }

  }
}
