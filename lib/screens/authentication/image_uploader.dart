import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lib/Home/home.dart';
import 'package:lib/screens/authentication/register.dart';

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  List<File?> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  Future<void> _uploadImage(File image, var count) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference reference =
      FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      final UploadTask uploadTask = reference.putFile(image);

      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();
      /*if(_selectedImages.length == 0) {
        await firestore.collection('users')
        .doc(userId).collection('profile').doc('User_Images').set({
          'MainImage': downloadURL,
        });
      }else if(_selectedImages.length == 1) {
        await firestore.collection('users')
            .doc(userId).collection('profile').doc('User_Images').set({
          'Img2': downloadURL,

        });
      }else {*/
        //print(count);
        await firestore.collection('users')
            .doc(userId!).collection('profile').doc('images')
            .set({'Img $count': downloadURL},  SetOptions(merge: true)

        );

      //}
      print('Image uploaded. Download URL: $downloadURL');
    } on FirebaseException catch (e) {
      print('Error uploading image to Firebase: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _selectedImages.add(File(pickedImage.path));
      });
    }
  }

  Widget _buildImagePreview(File? image) {
    if (image == null) {
      return Container();
    }

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UMD Match'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Text('Take Photo'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text('Pick from Gallery'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: _selectedImages
                .map((image) => _buildImagePreview(image))
                .toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_selectedImages.length == 3) {
                var count = 1;
                for (final image in _selectedImages) {
                  _uploadImage(image!, count);
                  count ++;
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutYourself()));

              } else {
                print('Please select three images.');
              }
            },
            child: Text('Upload Images'),
          ),
        ],
      ),
    );
  }
}
