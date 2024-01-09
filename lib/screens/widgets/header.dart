import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget{

  const Header({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("UMD Match"),
          centerTitle: true,
          backgroundColor: Colors.red.shade800,
        )
    );
  }
}