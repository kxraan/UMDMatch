import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'image_uploader.dart';




class GenderPref extends StatefulWidget {
  @override
  _GenderPrefState createState() => _GenderPrefState();
}

class _GenderPrefState extends State<GenderPref> {
  String dropDownVal = 'Male';

  Future<void> storeUserGenderPref(String gender) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId!).collection('profile').doc('required')
          .set({'gender_pref': gender.trim()}, SetOptions(merge: true));
      print('User gender pref stored successfully.');
    } catch (error) {
      print('Failed to store user gender pref: $error');
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
              'Choose Your Gender Preference',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              isExpanded: true,
              value: dropDownVal,
              hint: Text('Select Gender'),
              onChanged: (newValue) {
                setState(() {
                  dropDownVal = newValue!;
                });
              },
              items:
              <String>['Male', 'Female', 'Nonbinary'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    storeUserGenderPref(dropDownVal);
                    Navigator.push(context,

                        MaterialPageRoute(builder: (context) => ImageUploader()));

                  },
                  icon: Icon(Icons.arrow_forward),
                  color: Colors.red,
                  splashColor: Colors.redAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
