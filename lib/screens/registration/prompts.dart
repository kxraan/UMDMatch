import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/nav_bar.dart';
import 'clubs.dart';




class Prompts extends StatefulWidget {
  @override
  _PromptsState createState() => _PromptsState();
}

class _PromptsState extends State<Prompts> {

  Future<void> storePrompt(String prompt,String promptQues,Prompts widget) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId).collection('profile').doc('prompts')
          .set({ promptQues: prompt.trim()}, SetOptions(merge: true));
      print('User prompts stored successfully.');
    } catch (error) {
      print('Failed to store user prompts: $error');
    }
  }
  String? getUser() {
    User? currentUser =  FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);
    return userId;
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
                              NavBar())); //ChatPage(userId:getUser() as String,recipientId: 'getkaran',)
                    },
                    child: Text('SKIP'),

                  ),
                  IconButton(
                    onPressed: () {
                      //try {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Clubs()));//ChatPage(userId:getUser() as String,recipientId: 'getkaran',)
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
