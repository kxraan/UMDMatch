import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          .collection('profile')
          .doc('required')
          .get();

      var snapshotImg = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('images')
          .get();

      if (snapshot.exists) {
        setState(() {
          userName = snapshot['name'];
          userEmail = snapshot['email'];
        });
      } else {
        print('Document does not exist');
      }

      if (snapshotImg.exists) {
        setState(() {
          userImgUrl = snapshotImg['Img 1'];
        });
      } else {
        print('Image document does not exist');
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }

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
  @override
  void initState() {
    super.initState();
    getCurrentUserId().then((uid) {
      setState(() {
        userId = uid!; // Assign userId after retrieval
      });
      fetchUserInfo();
    });
  }


  Future<String?> getCurrentUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        return userId;
      } else {
        return null;
      }
    } catch(e) {
      print("Error getting current user ID: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: userImgUrl.isNotEmpty
                  ? NetworkImage(userImgUrl) as ImageProvider<Object>?
                  : AssetImage("assets/images/karan1.jpg"),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: $userName",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Email: $userEmail",
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
                          currentName: userName,
                          currentEmail: userEmail,
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
