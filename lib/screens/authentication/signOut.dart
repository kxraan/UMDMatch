import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

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
        },
        icon:Icon(
            Icons.person
        ),

        label: Text("Logout"),
      ),
    );

  }
}