import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lib/Models/user.dart';
import 'package:lib/screens/authentication/signOut.dart';
import '../../Home/home.dart';
import 'auth.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  /* final Function toggleView;
  Register({required this.toggleView});*/

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final picker = ImagePicker();
  PickedFile image = PickedFile("");
  Future getimage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile as PickedFile;
    });
  }

  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = 'begbeb1';
  String error = '';
  String name = '';
  String age = '';
  String major = '';
  String sex = '';
  String genderpref = '';
  String hobbies = '';
  String location = '';

  static final  TextEditingController nameController = TextEditingController();
  Future<void> storeUserName(String name) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    try {
      //DateTime dobDate = DateTime.parse(dob);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('required')
          .set({'name' : name.trim()}, SetOptions(merge: true));
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
            ),
            SizedBox(height: 16.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Spacer(),
              IconButton(
                onPressed: () {
                  //try {
                  storeUserName(nameController.text);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DateofBirth()));
                },
                        /*.then((value) async
                    {
                      await FirebaseFirestore.instance.collection("users").doc(
                          value.user.uid).set({
                        "name": nameController.text.trim()
                      });
                    }
                    );
                  }catch (error) {
                    print('Failed to store user name: $error');
                  }
                },*/
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

class DateofBirth extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();

  Future<void> storeUserDOB(String dob) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
       try {
         DateTime dobDate = DateTime.parse(dob);
         await FirebaseFirestore.instance
             .collection('users')
             .doc(userId).collection('profile').doc('required')
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
              controller: dateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'MM/DD/YYYY',
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
                  storeUserDOB(dateController.text);
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

class Major extends StatefulWidget {
  @override
  _MajorState createState() => _MajorState();

}

class _MajorState extends State<Major> {
  // GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

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
    loadCSVData();
  }

  Future<void> loadCSVData() async {
    final data = await loadCSV();
    setState(() {
      _data = data;
    });
  }

  Future<void> storeUserMajor(String major) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('required')
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
            DropdownButton<String>(
              isExpanded: true,
              value: dropDownVal,
              hint: Text('Select Major'),
              onChanged: (newValue) {
                setState(() {
                  dropDownVal = newValue!;
                });
              },
              items: _data.map((List<dynamic> row) {
                return DropdownMenuItem<String>(
                  value: row[0].toString(),
                  child: Text(row[0].toString()),
                );
              }).toList(),
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
            ])
          ],
        ),
      ),
    );
  }
}

class Gender extends StatefulWidget {
  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String dropDownVal = 'Male';


  Future<void> storeUserGender(String gender) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('required')
          .set({'gender': gender.trim()}, SetOptions(merge: true));
      print('User gender stored successfully.');
    } catch (error) {
      print('Failed to store user gender: $error');
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
        padding:EdgeInsets.symmetric(vertical: 70.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Choose Your Gender',
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
                    storeUserGender(dropDownVal);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GenderPref()));
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

class GenderPref extends StatefulWidget {
  @override
  _GenderPrefState createState() => _GenderPrefState();
}

class _GenderPrefState extends State<GenderPref> {
  String dropDownVal = 'Male';

  Future<void> storeUserGenderPref(String gender) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('required')
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
                        MaterialPageRoute(builder: (context) => signOut()));
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
