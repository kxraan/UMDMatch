import 'package:flutter/material.dart';
import 'package:lib/screens/widgets/potrait.dart';
import 'package:lib/screens/widgets/rounded_button.dart';
import 'package:lib/screens/widgets/rounded_outlined_button.dart';
import 'package:provider/provider.dart';
import '../database/app_user.dart';
import '../database/user_options.dart';
import 'chat.dart';

class MatchedScreen extends StatelessWidget {
  static const String id = '/matched_screen';

  final ImageInfo myProfilePhotoPath;
  final String myUserId;
  final ImageInfo otherUserProfilePhotoPath;
  final String otherUserId;
  final UserOptions option;

  MatchedScreen(
      {required this.myProfilePhotoPath,
        required this.myUserId,
        required this.otherUserProfilePhotoPath,
        required this.otherUserId,
        required this.option});

  void sendMessagePressed(BuildContext context) async {

    final AppUser appUser = Provider.of<AppUser>(context, listen: false);

    /**
     * TODO: chat gets added in moth the user only if 'send message' is selected
     */

    await appUser.start_chat(this.option);

    Navigator.pop(context);

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ChatPage(userId: myUserId, recipientId: otherUserId, name: option.required['name'], image: option.images['Img 1'],)
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
                    Portrait(imageInfo: myProfilePhotoPath),
                    Portrait(imageInfo: otherUserProfilePhotoPath)
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