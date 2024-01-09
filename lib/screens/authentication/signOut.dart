import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib/screens/authentication/sign_in.dart';

import 'auth.dart';


/*
TODO
Problem: if the person has logged out the google account and then try to log out
of the app, then the signout won't take place and will give an error
 */

class signOut extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Container(

      width: double.infinity,
      height: 350,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(64),
            bottomRight: Radius.circular(64),
          ),
        ),
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFFFD0E42),
            Color(0xFFC30F31),
          ],
        ),
      ),
      child:TextButton.icon(
        onPressed:() async {
          await _auth.signout();
          SignIn();
        },
        icon:Icon(
            Icons.person
        ),

        label: Text("Logout"),
      ),
    );

  }
}