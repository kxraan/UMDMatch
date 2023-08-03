import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:lib/Models/user.dart';
import 'package:lib/screens/authentication/signOut.dart';
import '../../Home/home.dart';
//import '../../services/auth.dart';
import 'auth.dart';
import 'image_uploader.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
//import 'auth.dart';
//import 'email_verification_page.dart';
//import 'package:dropdown_search/dropdown_search.dart';


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
  final _formKey = GlobalKey<FormState>();
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
  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
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
              key:formKey,
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: _validateTextField,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      storeUserName(nameController.text);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DateofBirth()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in the required field.'),
                        ),
                      );
                    }

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

class DateofBirth extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final formKeyDate = GlobalKey<FormState>();
  final formKeyYear = GlobalKey<FormState>();
  final formKeyMonth = GlobalKey<FormState>();

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

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
              key: formKeyYear,
              controller: yearController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Year',
                hintText: 'YYYY',
                border: OutlineInputBorder(),
              ),
              validator: _validateTextField,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              key: formKeyMonth,
              controller: monthController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Month',
                hintText: 'MM',
                border: OutlineInputBorder(),
              ),
              validator: _validateTextField,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              key: formKeyDate,
              controller: dateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'DD',
                border: OutlineInputBorder(),
              ),
              validator: _validateTextField,
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
                  if(formKeyDate.currentState!.validate() && formKeyMonth.currentState!.validate() && formKeyYear.currentState!.validate()){
                    String dob = yearController.text + "/"+ monthController.text + "/" + dateController.text;
                    storeUserDOB(dob);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Major()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill in the required field.'),
                      ),
                    );
                  }

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
  void saveSelectedOptions(List<String> selectedOptions) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? currentUserId = currentUser?.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId).collection('profile').doc('required')
          .set({'gender_pref': selectedOptions}, SetOptions(merge: true));
      print('Selected options stored in Firebase successfully.');
    } catch (error) {
      print('Failed to store selected options in Firebase: $error');
    }
  }
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
              'Choose Your Gender Preference',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),

            MultiSelectDialogField(
              items:  <String>['Male', 'Female', 'Nonbinary'].map((e) => MultiSelectItem(e, e)).toList(),
              listType: MultiSelectListType.CHIP,
              initialValue: _selectedOptions,
              onConfirm: (selectedItems) {
                setState(() {
                  _selectedOptions = selectedItems;
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

// class _uploadImg extends StatefulWidget {
//   @override
//   _uploadImgState createState() => _uploadImgState();
// }
//
// class _uploadImgState extends State<_uploadImg> {
//   Uint8List? _image;
//   void selectImage() async {
//     Uint8List img = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = img;
//     });
//   }
//   void saveProfile() async{
//     String resp = await StoreData().saveData(file: _image!);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("UMD Match"),
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 32,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: 24,
//               ),
//               Stack (
//                 children: [
//                   _image != null
//                       ? CircleAvatar(
//                     radius: 64,
//                     backgroundImage: MemoryImage(_image!),
//                   )
//                       : const CircleAvatar(
//                     radius: 64,
//                     backgroundImage: NetworkImage(
//                         'https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png'),
//                   ),
//                   Positioned(
//                     bottom: -10,
//                     left: 80,
//                     child: IconButton(
//                       onPressed: selectImage,
//                       icon: const Icon(Icons.add_a_photo),
//                     ),
//                   )
//                 ],
//
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               ElevatedButton(
//                 onPressed: saveProfile,
//                 child: const Text('Save Profile'),
//               )
//
//
//             ],
//           ),
//         ),
//
//
//       ),
//     );
//
//   }
// }



// class UserImg extends StatefulWidget {
//
//   final Function(String imageUrl) onFileChanged;
//   UserImg( {
//     required this.onFileChanged,
//   });
//   @override
//   _UserImgState createState() => _UserImgState();
//
//
// }
// class _UserImgState extends State<UserImg> {
//   final ImagePicker _picker = ImagePicker();
//
//   String? imageUrl;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if(imageUrl == null)
//           Icon(Icons.image,size: 60,color: Theme.of(context).primaryColor),
//         if(imageUrl != null)
//           InkWell(
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             onTap: () => _selectPhoto(),
//             child: AppRoundImage.url (
//               imageUrl!,
//               width:80,
//               height:80,
//             ),
//           ),
//         InkWell(
//           onTap: () => _selectPhoto(context),
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(imageUrl != null? 'Change Photo': 'Select Photo',
//               style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//
//       ],
//     );
//   }
// }
// Future _selectPhoto(context) async {
//   await showModalBottomSheet (context: context, builder: (context) => BottomSheet (
//     builder: (context) => Column ( mainAxisSize: MainAxisSize.min, children: [
//       ListTile(leading: Icon (Icons.camera), title: Text('Camera'), onTap: () {
//         Navigator.of(context).pop();
//         _pickImage (ImageSource .camera);
//       }),
//       ListTile(leading: Icon(Icons.filter), title: Text('Pick a file'), onTap: () {
//         Navigator.of(context).pop();
//         _pickImage(ImageSource.gallery);
//       }),
//     ],
//     ),
//     onClosing: () {}, )); // BottomSheet
// }
//
//
// Future _pickImage(ImageSource img) async {
//   final pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
//   if(pickedFile == null) {
//     return;
//   }
//   var file = await ImageCropper.cropImage(sourcePath: pickedFile.path, aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1) );
//   if(file == null) {
//     return;
//   }
//
//   file = await compressImage(file.path,35) ;
//   await _uploadFile(file.path);
//
// }
//
// Future compressImage(String path, int quality) async {
//   final newPath = p.join((await getTemporaryDirectory()).path,'${DateTime.now()}.${p.extension(path)}');
//
//   final result = await FlutterImageCompress.compressAndGetFile(
//     path, newPath, quality: quality,
//   );
//   return result;
// }
//
// Future _uploadFile(String path) async {
//   final ref = storage.FirebaseStorage.instance.ref().child ('images').child('${DateTime.now().toIso8601String() + p.basename (path)}');
//
//   final result = await ref.putFile(File(path));
//   final fileUrl = await result.ref.getDownloadURL();
//
//   setState((){imageUrl = fileUrl;});
//
//   widget.onFileChanged(fileUrl);
// }
class AboutYourself extends StatefulWidget {
  @override
  _AboutYourselfState createState() => _AboutYourselfState();
}

class _AboutYourselfState extends State<AboutYourself> {

  Future<void> storeAboutYourself(String about, AboutYourself widget) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('optional')
          .set({'aboutyourself': about.trim()}, SetOptions(merge: true));
      print('User gender pref stored successfully.');
    } catch (error) {
      print('Failed to store user gender pref: $error');
    }

  }
  String? getUser() {
    User? currentUser =  FirebaseAuth.instance.currentUser;
    String? currentUserId = currentUser?.uid;
    return currentUserId;
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
              'About Yourself',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: textController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Tell others more about yourself!',
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
                              Residence())); //ChatPage(userId:getUser() as String,recipientId: 'getkaran',)
                  },
                  child: Text('SKIP'),

               ),
               IconButton(
                 onPressed: () {
                  //try {
                  storeAboutYourself(textController.text,widget);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Residence()));//ChatPage(userId:getUser() as String,recipientId: 'getkaran',)
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


class Residence extends StatefulWidget {
  @override
  _ResidenceState createState() => _ResidenceState();
}

class _ResidenceState extends State<Residence> {

  Future<void> storeResidence(String residence, Residence widget) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
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
    String? currentUserId = currentUser?.uid;
    return currentUserId;
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

class Prompts extends StatefulWidget {
  @override
  _PromptsState createState() => _PromptsState();
}

class _PromptsState extends State<Prompts> {

  Future<void> storePrompt(String prompt,String promptQues,Prompts widget) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('optional')
          .set({ promptQues: prompt.trim()}, SetOptions(merge: true));
      print('User prompts stored successfully.');
    } catch (error) {
      print('Failed to store user prompts: $error');
    }
  }
  String? getUser() {
    User? currentUser =  FirebaseAuth.instance.currentUser;
    String? currentUserId = currentUser?.uid;
    return currentUserId;
  }
  String prompt1 = 'My go-to spot to hang out late at night on campus is…..';
  String prompt2 = 'I believe most Terps are….';
  String prompt3 = 'Imagine you bump into Testudo on a midnight stroll across campus. What would you say or do?';
  List<String> prompts = [];
  List<String> selectedPrompts = [];
  late TextEditingController textController;
  bool answered = false;
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  //static final  TextEditingController textController = TextEditingController();

  Future openDialog1() => showDialog(
      context: context,
      builder: (context) => SimpleDialog(
          title: Text("Choose a Prompt"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                openDialog2(prompt1);
              },
              child: Text(prompt1),
            ),
            SimpleDialogOption(
              onPressed: (){
                openDialog2(prompt1);
              },
              child: Text(prompt2),
            ),
            SimpleDialogOption(
              onPressed: () {
                openDialog2(prompt3);
              },
              child: Text(prompt3),
            )
          ],
        ),
  );

  Future openDialog2(String prompt) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(prompt),
        content: TextField(
          autofocus: true,
          controller: textController,
          keyboardType: TextInputType.text,
        ),
        actions: [
          TextButton(
              onPressed: () {
                storePrompt(textController.text, prompt, widget);
                Navigator.of(context).pop();
              },
              child: Text('Done'),
          )
        ],

      )
  );


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
            const SizedBox(height: 16.0,),
            Text(
              "Make your profile standout by adding prompts to your profile!",
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 20,
               ),
            ),
            const SizedBox(height: 16.0,),
            ElevatedButton(
                onPressed: () async {
                  openDialog1();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Add Prompt"),
                    Icon(Icons.add),
                  ],
                ),


            ),
            SizedBox(height: 16.0),
            SizedBox(height: 16.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              Home())); //ChatPage(userId:getUser() as String,recipientId: 'getkaran',)
                    },
                    child: Text('SKIP'),

                  ),
                  IconButton(
                    onPressed: () {
                      //try {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));//ChatPage(userId:getUser() as String,recipientId: 'getkaran',)
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

