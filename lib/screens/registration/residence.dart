import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib/screens/registration/prompts.dart';




class Residence extends StatefulWidget {
  @override
  _ResidenceState createState() => _ResidenceState();
}

class _ResidenceState extends State<Residence> {

  Future<void> storeResidence(String residence, Residence widget) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = getUser();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('optional')
          .set({'residence': residence.trim()}, SetOptions(merge: true));
      print('User residence stored successfully.');
    } catch (error) {
      print('Failed to store user residence: $error');
    }

  }
  String? getUser() {
    User? currentUser =  FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);
    return userId;
  }
  static final  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("UMD Match"),
        centerTitle: true,
        backgroundColor: Colors.red.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Apartment/Residence Hall',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: textController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              Prompts())); //ChatPage(userId:getUser() as String,recipientId: 'getkaran',)
                    },
                    child: Text('SKIP'),

                  ),
                  IconButton(
                    onPressed: () {
                      //try {
                      storeResidence(textController.text,widget);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Prompts()));//ChatPage(userId:getUser() as String,recipientId: 'getkaran',)
                    },
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.red,
                    splashColor: Colors.redAccent,
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
