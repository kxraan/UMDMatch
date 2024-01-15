import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../database/app_user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userId = "";
  late String userName = "";
  late String userEmail = "";
  late String userImgUrl = "";
  late Map<String,dynamic>? prompts;

  @override
  void initState() {
    super.initState();
    // Access the 'optional' data using Provider
    prompts = Provider.of<AppUser>(context, listen: false).prompts;
  }
  // Open the edit modal
  Future<void> _openEditModal(BuildContext context, String key, dynamic value) async {
    // Show your modal or navigate to a new page for editing
    // For simplicity, let's use showDialog as a modal
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit $key"),
          content: TextField(
            // Use a text field for simplicity, you might want to use a more complex input form
            controller: TextEditingController(text: value.toString()),
            onChanged: (newValue) {
              // Update the value when the user types
              value = newValue;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Save the updated value to the database and update the local map
                _updateValueInDatabase(key, value);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Update the value in the database and local map
  void _updateValueInDatabase(String key, dynamic value) {
    // Update the local map
    setState(() {
      prompts![key] = value;
    });
  }


/*
  Future<void> fetchUserInfo() async {
    if (userId == null) {
      print("User ID is not available yet.");
      return; // Exit if userId is not retrieved
    }
    try {
      userId = (await getCurrentUserId())!;
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profile');

      var snap = await snapshot.doc('required').get();

     // var snap = await snapshot.get();

      var snapshot1 = snap.data();

      var snapshotImg = await snapshot.doc('images')
          .get();

      if (snapshot1!.isNotEmpty) {
        setState(() {
         // print('hereeee');
          print(snapshot1['email']);
          userName = snapshot1['name'];
          userEmail = userId + '@terpmail.umd.edu';
        });
      } else {
        print('Document does not exist');
      }

      if (snapshotImg.exists) {
        setState(() {
          print('hereee');
          print( snapshotImg['Img 1']);
          userImgUrl = snapshotImg['Img 1'];
        });
      } else {
        print('Image document does not exist');
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }
*/

  // @override
  // void initState() {
  //   super.initState();
  //   // Fetch user information from Firebase
  //   fetchUserInfo().then((_) {
  //     // This block will be executed once fetchUserInfo is completed
  //     print("HELLO");
  //     print(userName);
  //     print(userImgUrl);
  //     print(userEmail);
  //
  //   });
  // }
 /* @override
  void initState() {
    super.initState();
    getCurrentUserId().then((uid) {
      setState(() {
        userId = uid!; // Assign userId after retrieval
      });
      fetchUserInfo();
    });
  }
*/
/*
  Future<String?> getCurrentUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? email = user?.email;
      var match = RegExp('([a-z]+)').firstMatch(email!);
      String? userId = match?.group(0);

      if (userId != null) {
       // String userId = userId;

        return userId;
      } else {
        return null;
      }
    } catch(e) {
      print("Error getting current user ID: $e");
      return null;
    }
  }*/

  @override
  Widget build(BuildContext context) {

    final AppUser appUser = Provider.of<AppUser>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            "Profile",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: /*userImgUrl.isNotEmpty
                  ?*/ NetworkImage(appUser.images?['Img 1'])
                  //: AssetImage("assets/images/karan1.jpg"),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: " + appUser.required?['name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Email: " + appUser.id,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the edit profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          currentName: appUser.required?['name'],
                          currentEmail: appUser.id,
                          onUpdate: (newName, newEmail) {
                            // Update the user information
                            setState(() {
                              userName = newName;
                              userEmail = newEmail;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Text("Edit Profile"),
                ),
                if (prompts != null)
                  Column(
                    children: [
                      Text(
                        "Prompts",
                      ),
                      SizedBox(height:20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: prompts!.entries.map((entry) {
                          return Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "${entry.key}: ${entry.value}",
                                  style: TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.keyboard_arrow_right_rounded),
                                  onPressed:() {
                                    _openEditModal(context, entry.key, entry.value);
                                  },
                              ),

                            ],
                          );
                        }).toList(),
                      )
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final Function(String, String) onUpdate;

  EditProfilePage(
      {required this.currentName,
        required this.currentEmail,
        required this.onUpdate}
      );

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Center(
            child: Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Pass updated information back to the profile page
                  widget.onUpdate(nameController.text, emailController.text);
                  Navigator.pop(context); // Go back to the profile page
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
        );
    }
}
