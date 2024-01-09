import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'major.dart';




class DateofBirth extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();

  Future<void> storeUserDOB(String dob) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);
    try {
      DateTime dobDate = DateTime.parse(dob);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId!).collection('profile').doc('required')
          .set({'dob': Timestamp.fromDate(dobDate)}, SetOptions(merge: true));
      print('User date of birth stored successfully.');
    } catch (error) {
      print('Failed to store user date of birth: $error');
    }
  }

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
              'Enter Your Date of Birth',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: yearController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Year',
                hintText: 'YYYY',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: monthController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Month',
                hintText: 'MM',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: dateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Day',
                hintText: 'DD',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.red,
                splashColor: Colors.redAccent,
              ),
              IconButton(
                onPressed: () {
                  String dob = yearController.text + "-"+ monthController.text + "-" + dateController.text;
                  storeUserDOB(dob);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Major()));
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
