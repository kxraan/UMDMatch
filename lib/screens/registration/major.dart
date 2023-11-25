import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gender.dart';




class Major extends StatefulWidget {
  @override
  _MajorState createState() => _MajorState();

}

class _MajorState extends State<Major> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  String dropDownVal = 'Undecided/Undeclared';
  List<List<dynamic>> _data = [];
  Future<List<List<dynamic>>> loadCSV() async {
    final rawData = await rootBundle.loadString("assets/CSVFiles/majors.csv");
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

  Future<void> storeUserMajor(String major) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId!).collection('profile').doc('required')
          .set({'major': major.trim()}, SetOptions(merge: true));
      print('User major stored successfully.');
    } catch (error) {
      print('Failed to store user major: $error');
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
              'Choose Your Major',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _data.map((List<dynamic> row) {
                  return row[0].toString();
                }).where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String option) {
                setState(() {
                  dropDownVal = option;
                  print('The $option was selected');
                });
              },
              // fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
              //   return TextFormField(
              //     controller: textEditingController,
              //     decoration: InputDecoration(
              //       labelText: 'Select Major',
              //     ),
              //   );
              // },
              // isExpanded: true,
              // value: dropDownVal,
              // hint: Text('Select Major'),
              // onChanged: (newValue) {
              //   setState(() {
              //     dropDownVal = newValue!;
              //   });
              // },
              // items: _data.map((List<dynamic> row) {
              //   return DropdownMenuItem<String>(
              //     value: row[0].toString(),
              //     child: Text(row[0].toString()),
              //   );
              // }).toList(),
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
                  storeUserMajor(dropDownVal);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Gender()));
                },
                icon: Icon(Icons.arrow_forward),
                color: Colors.red,
                splashColor: Colors.redAccent,
              ),
            ] )
          ],
        ),
      ),
    );
  }
}
