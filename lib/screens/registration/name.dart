import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dob.dart';



class Name extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  /* final Function toggleView;
  Register({required this.toggleView});*/

  @override
  State<Name> createState() => _RegisterState();
}

class _RegisterState extends State<Name> {

  static final  TextEditingController nameController = TextEditingController();
  Future<void> storeUserName(String name) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;


    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId!)
        .set({'email' : email.trim()}, SetOptions(merge: true));

    try {
      //DateTime dobDate = DateTime.parse(dob);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId!).collection('profile').doc('required')
          .set({'name' : name.trim()}, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId!).collection('profile').doc('required')
          .set({'id' : userId.trim()}, SetOptions(merge: true));
      print('User name stored successfully.');
    } catch (error) {
      print('Failed to store user name: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*TODO validate scaffold */
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
              'Enter Your Name',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if(value!.isEmpty) {
                  return "Enter your name";
                }else {
                  return null;
                }
              },
            ),
            SizedBox(height: 16.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Spacer(),
              IconButton(
                onPressed: () {
                  storeUserName(nameController.text);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DateofBirth()));


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