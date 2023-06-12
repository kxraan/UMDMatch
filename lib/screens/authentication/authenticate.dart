import 'package:flutter/material.dart';
import 'package:umddating/screens/authentication/sign_in.dart';
import 'package:umddating/screens/authentication/register.dart';
class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
}
  @override
  Widget build(BuildContext context) {
    if(showSignIn) {
      return SignIn(toggleView: () {setState(() => showSignIn = !showSignIn);});
    }else {
      return Register(toggleView: () {setState(() => showSignIn = !showSignIn);});
    }

  }
}
