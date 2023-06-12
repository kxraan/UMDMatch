import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService(Map<dynamic, String> map, {this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');

  Future updateUserData(String name, String age, String sex, String genderpref) async {
    return await userCollection.doc(uid).set( {
      'name' : name,
      'age'  : age,
      'sex' : sex,
      'genderpref' : genderpref,
    });

  }
}