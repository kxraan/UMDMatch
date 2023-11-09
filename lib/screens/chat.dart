/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String userId; // The current user's ID
  final String recipientId; // The ID of the chat recipient

  ChatPage({required this.userId, required this.recipientId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? getUser() {
    User? currentUser =  FirebaseAuth.instance.currentUser;
    String? currentUserId = currentUser?.uid;
    return currentUserId;
  }
  Future<String> getNameofRecipient() async {
    DocumentSnapshot reqdDoc = await FirebaseFirestore.instance.collection('users')
        .doc(widget.recipientId).collection('profile').doc('required').get();
    String name = reqdDoc.get('name');
    return name;
  }
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getNameofRecipient(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              String recipientName = snapshot.data ?? 'Unknown';
              return Text(recipientName);
            }
          },
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users').doc(getUser()).collection('chats')
                  .doc(_getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isCurrentUser = message['sender'] == widget.userId;
                      return Bubble(
                        message: message['text'],
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getChatId() {
    // Sort the user IDs to ensure the chat ID is consistent for both users
    List<String> sortedUserIds = [widget.userId, widget.recipientId]..sort();
    return sortedUserIds.join('_');
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users').doc(getUser()).collection('chats')
          .doc(_getChatId())
          .collection('messages')
          .add({
        'text': messageText,
        'sender': widget.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }
}

class Bubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  Bubble({required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}*/

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ChatPage extends StatefulWidget {
//   final String userId; // The current user's ID
//   final String recipientId; // The ID of the chat recipient
//
//   ChatPage({required this.userId, required this.recipientId});
//
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   String? getUser() {
//     User? currentUser =  FirebaseAuth.instance.currentUser;
//     String? currentUserId = currentUser?.uid;
//     return currentUserId;
//   }
//   Future<String> getNameofRecipient() async {
//     DocumentSnapshot reqdDoc = await FirebaseFirestore.instance.collection('users')
//         .doc(widget.recipientId).collection('profile').doc('required').get();
//     String name = reqdDoc.get('name');
//     return name;
//   }
//   final TextEditingController _messageController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: FutureBuilder<String>(
//           future: getNameofRecipient(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Text('Loading...');
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               String recipientName = snapshot.data ?? 'Unknown';
//               return Text(recipientName);
//             }
//           },
//         ),
//         backgroundColor: Colors.red,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users').doc(getUser()).collection('chats')
//                   .doc(_getChatId())
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   var messages = snapshot.data!.docs;
//                   return ListView.builder(
//                     reverse: true,
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       var message = messages[index];
//                       bool isCurrentUser = message['sender'] == widget.userId;
//                       return Bubble(
//                         message: message['text'],
//                         isCurrentUser: isCurrentUser,
//                       );
//                     },
//                   );
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(hintText: 'Type your message...'),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: _sendMessage,
//                   icon: Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getChatId() {
//     // Sort the user IDs to ensure the chat ID is consistent for both users
//     List<String> sortedUserIds = [widget.userId, widget.recipientId]..sort();
//     return sortedUserIds.join('_');
//   }
//
//   void _sendMessage() {
//     String messageText = _messageController.text.trim();
//     if (messageText.isNotEmpty) {
//       FirebaseFirestore.instance
//           .collection('users').doc(getUser()).collection('chats')
//           .doc(_getChatId())
//           .collection('messages')
//           .add({
//         'text': messageText,
//         'sender': widget.userId,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       _messageController.clear();
//     }
//   }
// }
//
// class Bubble extends StatelessWidget {
//   final String message;
//   final bool isCurrentUser;
//
//   Bubble({required this.message, required this.isCurrentUser});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         padding: EdgeInsets.all(12),
//         margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         decoration: BoxDecoration(
//           color: isCurrentUser ? Colors.blue : Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Text(
//           message,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
//
//
// class ChatPageList extends StatelessWidget {
//  final List<String> chatNames = [
//    'Karan',
//    'test2',
//    'test3',
//  ];
//  String? getUser() {
//     User? currentUser =  FirebaseAuth.instance.currentUser;
//     String? currentUserId = currentUser?.uid;
//     return currentUserId;
//   }
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      itemCount: chatNames.length,
//      itemBuilder: (context,index){
//        return ListTile(
//         leading: Icon(Icons.person),
//         title: Text(chatNames[index]),
//         onTap: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) =>ChatPage(userId: getUser() as String,recipientId: chatNames[index],) ));
//         },
//       );
//     },
//   );
// }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChatPage extends StatefulWidget {
  final String userId; // The current user's ID
  final String recipientId; // The ID of the chat recipient

  ChatPage({required this.userId, required this.recipientId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Future<String?> getUser() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);

    return userId;
  }

  Future<String> getNameofRecipient() async {
    DocumentSnapshot reqdDoc = await FirebaseFirestore.instance.collection('users')
        .doc(widget.recipientId).collection('profile').doc('required').get();
    String name = reqdDoc.get('name');
    return name;
  }
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getNameofRecipient(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              String recipientName = snapshot.data ?? 'Unknown';
              return Text(recipientName);
            }
          },
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users').doc(getUser() as String?).collection('chats')
                  .doc(_getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isCurrentUser = message['sender'] == widget.userId;
                      return Bubble(
                        message: message['text'],
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getChatId() {
    // Sort the user IDs to ensure the chat ID is consistent for both users
    List<String> sortedUserIds = [widget.userId, widget.recipientId]..sort();
    return sortedUserIds.join('_');
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users').doc(getUser() as String?).collection('chats')
          .doc(_getChatId())
          .collection('messages')
          .add({
        'text': messageText,
        'sender': widget.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }
}

class Bubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  Bubble({required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ChatPageList extends StatefulWidget{
  const ChatPageList({Key? key}) : super(key: key);

  @override
  State<ChatPageList> createState() => _ChatPageList();
}

class _ChatPageList extends State<ChatPageList> {
   List<String> chatNames = [

  ];
  Future<List<String>> user_initialize() async{
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);

    var chat_data = await FirebaseFirestore.instance
        .collection('users').doc(userId).collection('chat');

    QuerySnapshot<Map<String, dynamic>> chat_doc = await chat_data.get();

    for(var doc in chat_doc.docs){
      var chat_name = doc.data().values.toString();

      RegExp pattern = RegExp(r'\((.*?)&(.*)\)');

      // Applying the pattern to the data string
      RegExpMatch? match = pattern.firstMatch(chat_name);

      if (match != null) {
        String beforeAmpersand = match.group(1)!; // Text before '&'
        String afterAmpersand = match.group(2)!; // Text after '&'

        if(beforeAmpersand == userId)
          chat_name = afterAmpersand;
        else
          chat_name = beforeAmpersand;

      }
      chatNames.add(chat_name);
      print(chat_name);
    }

    return chatNames;
  }

  @override
  void initState(){
    super.initState();
    user_initialize().then((value){
      setState((){

      });
    });
  }

  Future<String?> getUser() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);

    return userId;
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatNames.length,
      itemBuilder: (context,index){
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(chatNames[index]),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>ChatPage(userId: getUser() as String,recipientId: chatNames[index],) ));
          },
        );
      },
    );
  }

}
