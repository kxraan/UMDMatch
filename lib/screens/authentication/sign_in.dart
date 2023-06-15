import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';


import 'auth.dart';
import 'email_verification_page.dart';



class SignIn extends StatefulWidget {
 // const SignIn({Key? key}) : super(key: key);
/*  final Function toggleView;
  SignIn({required this.toggleView});*/
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("UMD Dating App"),
          centerTitle: true,
          backgroundColor: Colors.red.shade800,/*
          actions: [
            TextButton.icon(
                onPressed: (){
                  widget.toggleView();
                },
                icon: Icon(Icons.person),
                label: Text("Register"),
            )
          ],*/
        ),
        body:Center(
          child: Padding (
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                RichText(
                  text: const TextSpan(
                    text: 'Please use ',
                    style: TextStyle(
                      color:  Colors.black,
                      fontSize: 20
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Terpmail', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' account for verification'),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                SignInButtonBuilder(
                    image: Image.asset('assets/images/google_logo.png',
                        scale: 20),

                    text: "Log In or Sign Up",
                    backgroundColor:Colors.white ,
                    textColor: Colors.black,
                    highlightColor: Colors.redAccent,
                    onPressed: ()async{
                      _auth.signInWithGoogle(context: context);
                    }
                ),

              ],
            ),
          ),
          ),

        )
    );

  }
}
