import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';


import '../../services/auth.dart';



class SignIn extends StatefulWidget {
 // const SignIn({Key? key}) : super(key: key);
  final Function toggleView;
  SignIn({required this.toggleView});
  @override
  State<SignIn> createState() => _SignInState();
}


class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String error = '';
  String email = '';
  String password = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();


  EmailAuth emailAuth = new EmailAuth(
    sessionName: "Sample session",
  );

  @override
 /* void initState() {
    super.initState();
    emailAuth.config(remoteServerConfiguration);

  }*/



  void sendOtp() async {
    var result = await emailAuth.sendOtp(
        recipientMail: _emailController.text, otpLength: 5
    );
    if(result) {
      print("OTP Sent");
    }else {
      print("OTP was not sent");
    }
  }
  void verifyOtp() async {
    var res = emailAuth.validateOtp(
        recipientMail: _emailController.text,
        userOtp: _otpController.value.text);
    if(res) {
      print("Verified");
    }else {
      print("INVALID OTP");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("UMD MATCH"),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: [
            TextButton.icon(
                onPressed: (){
                  widget.toggleView();
                },
                icon: Icon(Icons.person),
                label: Text("Register"),
            )
          ],
        ),
        body:Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,

                  validator: (val) {
                    if(val!.isEmpty) {
                      return "Enter an email address";
                    }
                    if(!val.endsWith("umd.edu")) {
                      return "Email address must be a UMD email address.";
                    }
                    return null;

                  },
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.length < 6 ? 'Enter a password with more than 6 characters' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20),
                /*ElevatedButton(
                    onPressed: () async{

                    },
                    child:ElevatedButton.icon(
                      onPressed: () => sendOtp(),
                      icon: Icon(
                        Icons.ac_unit
                      ),
                      label: Text("Send OTP"),

                      ),


                ),*/
                ElevatedButton(
                    onPressed: () async {

                    },
                    child:ElevatedButton.icon(
                       onPressed: () => verifyOtp()/* async {
                         if(formKey.currentState!.validate()) {
                           dynamic result = await _auth.signIn(email, password);
                           if(result == null) {
                             setState(() => error = 'Could not sign in with those credentials');
                           }
                         }
                       }*/,
                        icon: Icon(
                            Icons.account_circle
                        ),
                        label: Text("LOGIN"),
                      // style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    )

                ),

              ],
            ),
          ),
          /*ElevatedButton(
              onPressed: () {
              },
              child:ElevatedButton.icon(
                  onPressed: () {

                  },
                  icon: Icon(
                      Icons.account_circle
                  ),
                  label: Text("LOGIN")
                // style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              )

          ),*/

            /*ElevatedButton(
            onPressed: () {  },
            icon: Icon(
              Icons.
            )

          )*/


        )
    );

  }
}
