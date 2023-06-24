/*
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lib/Models/user.dart';
import 'package:flutter/material.dart';



 class Database extends GetxController{

  static Database get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  
  createUser(FbUser user) async{
    await _db.collection("Users").add(user.toJson()).whenComplete(() =>
    Get.snackbar("Success", "Account has been created",
    snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.redAccent
    ))
    .catchError((error, stackTrace){
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.redAccent
      );
      print(error.toString());
    });

  }
 }*/
