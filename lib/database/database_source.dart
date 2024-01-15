import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/widgets/constants.dart';

class FirebaseDatabase{
  final FirebaseFirestore instance = FirebaseFirestore.instance;


  String? getUserId()  {
    User? currentUser =  FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    /*
    TODO what about emails with numbers?
     */
    var match = RegExp('([a-z]+)').firstMatch(email!);
    var userId = match?.group(0);

    return userId;
  }

  get_required(String? userId) {
    return instance.collection('users').doc(userId).collection('profile').doc('required').get();
  }

  get_optional(String? userId) {
    return instance.collection('users').doc(userId).collection('profile').doc('optional').get();
  }

  get_prompts(String? userId) {
    return instance.collection('users').doc(userId).collection('profile').doc('prompts').get();
  }

  get_images(String? userId) {
    return instance.collection('users').doc(userId).collection('profile').doc('images').get();
  }

  get_matches(String? userId) async {
    var snap = instance.collection('users').doc(userId).collection('match').get();
    List<String> data = [];
    for(var doc in (await snap).docs){
      data.add(doc.id);
    }
    return data;
  }

  get_encountered(String? userId) async {
    var snap =  instance.collection('users').doc(userId).collection('encountered').get();

    Map <String, String> ids = {};
    for (var doc in (await snap).docs) {
    ids?[doc.data().values.toString()] ='';
    //encountered_ids.add(doc.data().values.toString());
    }

    return ids;
  }

  get_right(String userId) async{
    var snap =  instance.collection('users').doc(userId).collection('right').get();

    Map <String, String> ids = {};
    for (var doc in (await snap).docs) {
      ids?[doc.data().values.toString()] ='';
      //encountered_ids.add(doc.data().values.toString());
    }

    return ids;
  }

  set_encountered(String userId, String encounteredId){
    instance.collection('users')
        .doc(userId!).collection('encountered').doc(encounteredId)
        .set({'id' : encounteredId.trim()}, SetOptions(merge: true));
  }

  set_right(String userId, String rightId){
    instance.collection('users')
        .doc(userId!).collection('right').doc(rightId)
        .set({'id' : rightId.trim()}, SetOptions(merge: true));
  }

  set_left(String userId, String rightId){
    instance.collection('users')
        .doc(userId!).collection('left').doc(rightId)
        .set({'id' : rightId.trim()}, SetOptions(merge: true));
  }

  set_matches(String userId, String matchId){
    instance
        .collection('users')
        .doc(userId!).collection('match').doc(matchId)
        .set({'id' : matchId.trim()}, SetOptions(merge: true));

    instance
        .collection('users')
        .doc(matchId).collection('match').doc(userId!)
        .set({'id' : userId!.trim()}, SetOptions(merge: true));
  }

  start_chat(String userId, String chatId){

    var actualId = '';
    if(userId.compareTo(chatId) < 0){
      actualId = userId + '&' + chatId;
    }else{
      actualId = chatId + '&' + userId;
    }


    instance
        .collection('users')
        .doc(userId).collection('chat').doc( actualId)
        .set({'id' :chatId}, SetOptions(merge: true));

    instance
        .collection('users')
        .doc(chatId).collection('chat').doc( actualId)
        .set({'id' : userId}, SetOptions(merge: true));


  }

  /**
   * TODO:
   * Only checks for one preferred gender, there can be multiple
   */

  get_preferred_gender(String gender){
    return instance.collection(gender).get();
  }
}

