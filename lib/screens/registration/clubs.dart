import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../widgets/nav_bar.dart';




class Clubs extends StatefulWidget {
  @override
  _ClubsState createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  String dropDownVal = 'Male';

  List<List<dynamic>> _data = [];
  Future<List<List<dynamic>>> loadCSV() async {
    final rawData = await rootBundle.loadString("assets/CSVFiles/organizations.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    setState(() {
      _data = listData;
    });
    return listData;
  }

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSVData() async {
    final data = await loadCSV();
    setState(() {
      _data = data;
    });
  }

  void saveSelectedOptions(List<String> selectedOptions) async {

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      String? email = currentUser?.email;
      var match = RegExp('([a-z]+)').firstMatch(email!);
      String? userId = match?.group(0);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('required')
          .set({'gender_pref': selectedOptions}, SetOptions(merge: true));
      print('Selected options stored in Firebase successfully.');
    } catch (error) {
      print('Failed to store selected options in Firebase: $error');
    }
  }

  Future<void> storeUserClubs(String gender) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('optional')
          .set({'clubs': gender.trim()}, SetOptions(merge: true));
      print('User clubs stored successfully.');
    } catch (error) {
      print('Failed to store user clubs: $error');
    }
  }

  List<String> _selectedOptions = [];
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
              'Choose the clubs you are currently involved in',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            MultiSelectDialogField(
              items: _data.map((e) => MultiSelectItem(e, e as String)).toList(),
              listType: MultiSelectListType.CHIP,
              initialValue: _selectedOptions,
              onConfirm: (selectedItems) {
                setState(() {
                  _selectedOptions = selectedItems.map((e) => (e as String).toString()).toList();
                  // for(int i = 0; i < selectedItems.length; i ++) {
                  //   _selectedOptions[i] = selectedItems[i] as String;
                  // }
                });
                saveSelectedOptions(_selectedOptions);
              },
            ),
            SizedBox(height: 48.0),
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
                    storeUserClubs(dropDownVal);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NavBar()));
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
