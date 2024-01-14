import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lib/screens/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';
import '../database/app_user.dart';
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
  String _recipientName  = '';
  List<DocumentSnapshot> _messages = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMoreMessages = true;
  final int _messageLimit = 20;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

// ... (Rest of the initState and other methods will be in following snippets)

  @override
  void initState() {
    super.initState();
    _fetchRecipientName();
    _scrollController.addListener(_scrollListener);
    _loadInitialMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecipientName() async {
    try {
      DocumentSnapshot reqdDoc = await FirebaseFirestore.instance.collection('users')
          .doc(widget.recipientId).collection('profile').doc('required').get();
      String name = reqdDoc.get('name');
      setState(() {
        _recipientName  = name;
      });
    } catch (e) {
      print('Error fetching recipient name: $e');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange && _hasMoreMessages) {
      _loadMoreMessages();
    }
  }

  void _loadInitialMessages() async {
    var query = FirebaseFirestore.instance.collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(_messageLimit);

    query.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        if (mounted) {
          setState(() {
            _messages = snapshot.docs;
          });
        }
      }
    });
  }

  void _loadMoreMessages() {
    var query = FirebaseFirestore.instance.collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(_lastDocument!)
        .limit(_messageLimit);

    query.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        if (mounted) {
          setState(() {
            _messages.addAll(snapshot.docs);
            if (snapshot.docs.length < _messageLimit) _hasMoreMessages = false;
          });
        }
      }
    });
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {

      var chatId = _getChatId();
      var timestamp = FieldValue.serverTimestamp();

      FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': messageText,
        'sender': widget.userId,
        'timestamp': timestamp,
      });

      FirebaseFirestore.instance
          .collection('users').doc(widget.userId).collection('chat')
          .doc(chatId)
          .set({
        'lastMessage': messageText,
        'lastMessageTimestamp': timestamp,
      }, SetOptions(merge: true));

      FirebaseFirestore.instance
          .collection('users').doc(widget.recipientId).collection('chat')
          .doc(chatId)
          .set({
        'lastMessage': messageText,
        'lastMessageTimestamp': timestamp,
      }, SetOptions(merge: true));


      _messageController.clear();
    }
  }

  String _getChatId() {
    List<String> sortedUserIds = [widget.userId, widget.recipientId]..sort();
    return sortedUserIds.join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_recipientName.isNotEmpty ? _recipientName : 'Loading...'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isCurrentUser = message['sender'] == widget.userId;
                return Bubble(
                  message: message['text'],
                  isCurrentUser: isCurrentUser,
                );
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
                    decoration: InputDecoration(
                        hintText: 'Type your message...'),
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


  }



class ChatPageList extends StatefulWidget {
  const ChatPageList({Key? key}) : super(key: key);

  @override
  State<ChatPageList> createState() => _ChatPageList();
}

class _ChatPageList extends State<ChatPageList> {
  List<ChatMetadata> chats = []; // List to hold chat metadata

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final AppUser appUser = Provider.of<AppUser>(context, listen: false);

    // Fetch chats and order by last message timestamp
    var query = FirebaseFirestore.instance
        .collection('users').doc(appUser.id).collection('chat')
        .orderBy('lastMessageTimestamp', descending: true); // Adjust field name as necessary

    QuerySnapshot<Map<String, dynamic>> chatSnapshot = await query.get();

    List<ChatMetadata> fetchedChats = [];
    for (var doc in chatSnapshot.docs) {
      fetchedChats.add(ChatMetadata.fromDocument(doc,appUser.id));
    }

    if (mounted) {
      setState(() {
        chats = fetchedChats;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final AppUser appUser = Provider.of<AppUser>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users').doc(appUser.id).collection('chat')
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ChatMetadata> chats = snapshot.data!.docs
              .map((doc) => ChatMetadata.fromDocument(doc, appUser.id))
              .toList();

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(chats[index].chatPartnerId),
                subtitle: Text(chats[index].lastMessageText),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatPage(userId: appUser.id, recipientId: chats[index].chatPartnerId)));
                },
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


// Define a model for Chat Metadata
class ChatMetadata {
  final String userId;
  final String chatPartnerId;
  final String lastMessageText;
  final Timestamp lastMessageTimestamp;

  ChatMetadata({
    required this.userId,
    required this.chatPartnerId,
    required this.lastMessageText,
    required this.lastMessageTimestamp,
  });

  factory ChatMetadata.fromDocument(DocumentSnapshot doc, String userId) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //final AppUser appUser = Provider.of<AppUser>(context, listen: false);

    return ChatMetadata(
        userId: userId, // Adjust these fields based on your Firestore structure
        chatPartnerId: data['id'],
        lastMessageText: data['lastMessage'],
        lastMessageTimestamp: data['lastMessageTimestamp'],
    );
  }
}

