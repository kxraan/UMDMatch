import 'package:flutter/material.dart';
import 'package:lib/screens/widgets/potrait.dart';
import 'package:lib/screens/widgets/rounded_button.dart';
import 'package:lib/screens/widgets/rounded_outlined_button.dart';
import 'chat.dart';

class MatchedScreen extends StatelessWidget {
  static const String id = '/matched_screen';

  final String myProfilePhotoPath;
  final String myUserId;
  final String otherUserProfilePhotoPath;
  final String otherUserId;

  MatchedScreen(
      {required this.myProfilePhotoPath,
        required this.myUserId,
        required this.otherUserProfilePhotoPath,
        required this.otherUserId});

  void sendMessagePressed(BuildContext context) async {




    Navigator.pop(context);

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ChatPage(userId: myUserId, recipientId: otherUserId)
      ),
    );
   /*
    Navigator.pushNamed(context, ChatPage.id, arguments: {
     // "chat_id": compareAndCombineIds(myUserId, otherUserId),
      "userId": myUserId,
      "recipientId": otherUserId
    });*/
  }

  void keepSwipingPressed(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 42.0,
            horizontal: 18.0,
          ),
          margin: EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             // Image.asset('images/tinder_icon.png', width: 40),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Portrait(imageUrl: myProfilePhotoPath),
                    Portrait(imageUrl: otherUserProfilePhotoPath)
                  ],
                ),
              ),
              Column(
                children: [
                  RoundedButton(
                      text: 'SEND MESSAGE',
                      onPressed: () {
                        sendMessagePressed(context);
                      }),
                  SizedBox(height: 20),
                  RoundedOutlinedButton(
                      text: 'KEEP SWIPING',
                      onPressed: () {
                        keepSwipingPressed(context);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}