import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/widgets/constants.dart';

class Message {
  final String text;
  final String sender;
  final Timestamp timestamp; // Assuming you're using Firestore's Timestamp

  Message({
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  factory Message.fromSnapshot(DocumentSnapshot doc) {
    // Assuming your document has 'text', 'sender', and 'timestamp' fields
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      text: data['text'],
      sender: data['sender'],
      timestamp: data['timestamp'],
    );
  }
}


class ChatPage extends StatefulWidget {
  final String userId; // The current user's ID
  final String recipientId; // The ID of the chat recipient

  ChatPage({required this.userId, required this.recipientId});

  @override
  _ChatPageState createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage> {

  String? getUser() {
    print(currentUser);
    String? email = currentUser?.email;
    print(email);
    var match = RegExp('([a-z]+)').firstMatch(email!);
    print(match);
    String? userId = match?.group(0);
    print(userId);

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
              stream: FirebaseFirestore.instance.collection('chats')
                  .doc(_getChatId())
                  .collection('messages')
                  .orderBy('timestamp',descending: true)
                  .snapshots(),
              //collection('users')
              // .doc(getUser() as String?)
              // .collection('chats')
              // .doc(_getChatId())
              // .collection('messages')
              // .orderBy('timestamp', descending: true)
              // .snapshots(),



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
                    )
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
          .collection('chats')
          .doc(_getChatId())
          .collection('messages')
      // .collection('users').doc(getUser() as String?).collection('chats')
      // .doc(_getChatId())
      // .collection('messages')
          .add({
        'text': messageText,
        'sender': widget.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }
  @override
  void initState() {
    super.initState();

    // Add a listener for real-time updates
    FirebaseFirestore.instance
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .orderBy('timestamp',descending: true)
        .snapshots()
        .listen((querySnapshot) {
      setState(() {
        List<String?> updatedMessages = [];
        for (var doc in querySnapshot.docs) {
          updatedMessages.add(Message.fromSnapshot(doc) as String?);
        }

      });
    });
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
          color: isCurrentUser ? Colors.blue : Colors.red,
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

  String? getUser()  {
    print("CORRECT GET USER FUNCTION");

    String? email = currentUser!.email;
    print(email);
    var match = RegExp('([a-z]+)').firstMatch(email!);
    print(match);
    String? userId = match?.group(0);
    print(userId);
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

              String? temp = "";
              temp =  getUser();
              print(temp);
              print(chatNames[index]);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>ChatPage(userId: temp!,recipientId: chatNames[index],) ));
            },
          );
          },
        );
    }
}