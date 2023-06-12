import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:umddating/screens/wrapper.dart';
import 'package:umddating/services/auth.dart';

import 'Models/user.dart';
//void main() => runApp(const MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}
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

/*class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {*/

/*    return Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: Text("UMD Dating App"),
          centerTitle: true,
          backgroundColor: Colors.teal,

        ),
        body:Column(
          children: [
            Padding(
                padding: EdgeInsets.all(45),
                child: Column(
                  children: [
                    SizedBox(height:20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ],
                )
            ),
            ElevatedButton(
                onPressed: () {
                },
                child:ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => newPage()),
                      );
                    },
                    icon: Icon(
                        Icons.account_circle
                    ),
                    label: Text("LOGIN")
                  // style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                )

            ),

            /*ElevatedButton(
            onPressed: () {  },
            icon: Icon(
              Icons.
            )

          )*/


          ],

        )
    );*/


/*class newPage extends StatelessWidget {
  const newPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vibhu"),
        centerTitle: true,
        backgroundColor: Colors.white70,
      ),
    );

  }*/




/*Center(
        child: ElevatedButton.icon(
           onPressed: () {},
           icon: Icon(
             Icons.account_circle
           ),
           label: Text("Login"),
           style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            ),
        )*/


