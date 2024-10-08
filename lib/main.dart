import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lib/screens/authentication/sign_in.dart';
import 'package:lib/screens/widgets/splash.dart';

//import 'package:lib/firebase_options.dart';

import 'package:provider/provider.dart';
import 'database/app_user.dart';
import 'screens/home.dart';
import 'screens/wrapper.dart';
import 'screens/authentication/auth.dart';
//void main() => runApp(const MyApp());
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp();
  runApp( MyApp());

}
/*async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}*/
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AppUser appUser = AppUser();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<user_data?>.value(
          value: AuthService().user,
          initialData: null,
        ),
        ChangeNotifierProvider<AppUser>.value(
          value: appUser, // Provide the AppUser instance
        ),
      ],
      child: MaterialApp(
        home: SplashScreen(), // Earlier Wrapper()
      ),
    );
  }
}

