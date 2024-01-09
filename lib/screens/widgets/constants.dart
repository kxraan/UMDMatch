import 'package:firebase_auth/firebase_auth.dart';


late User? currentUser =  FirebaseAuth.instance.currentUser;
String? currentUserId = currentUser?.uid;
//return currentUserId;

late String userID;