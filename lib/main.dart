import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//import 'package:lib/firebase_options.dart';

import 'package:provider/provider.dart';

import 'Models/user.dart';
import 'screens/wrapper.dart';
import 'services/auth.dart';
//void main() => runApp(const MyApp());
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp();
  runApp(const MyApp());

}
/*async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FbUser?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          home: Wrapper(),
        )

    );


  }
}

