import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lib/database/user_options.dart';

import 'database_source.dart';

class AppUser extends ChangeNotifier {

  String id ='';
  Map<String, dynamic>? required;
  Map<String, dynamic>? images;
  Map<String, dynamic>? optional;
  Map<String, dynamic>? prompts;
  List <String>? matches;
  Map <String, String>? encountered_ids ;
  QuerySnapshot? preferred_genders;
  List<String>? option_ids =[];
  List<UserOptions> top3 =[];


  FirebaseDatabase _fb = new FirebaseDatabase();
  bool _initialized = false;

  Future<void> initialize() async {

    print('before');

    if(_initialized) return;

    this.id = (await _fb.getUserId())!;
    print('one');
      try {
        List<Future> allFutures = [
          _fb.get_required(this.id),
          _fb.get_images(this.id),
          _fb.get_optional(this.id),
          _fb.get_prompts(this.id),
          _fb.get_matches(this.id),
          _fb.get_encountered(this.id)
        ];

        var results = await Future.wait(allFutures);

        print('two');

        // Assuming the order of the futures in allFutures matches the order here
        this.required = results[0].data();
        this.images = results[1].data();
        this.optional = results[2].data();
        this.matches = results[3];
        this.encountered_ids = results[4];

        // Now handle the preferred_genders, which depends on `required`
        this.preferred_genders = await _fb.get_preferred_gender(required?['gender_pref']);
        get_option_ids();
        print('coming here');
        await initialize_options();
      } catch (e) {
        print(e.toString());
      }


  }


  get_option_ids(){

      for(DocumentSnapshot doc in preferred_genders!.docs){
          if (!encountered_ids!.containsKey('(' + doc.get('id') + ')')) {
            option_ids?.add(doc.get('id'));
          }
      }
      return option_ids;
  }

  initialize_options()  async {
    print('here?');
    while (top3.length < 3){
     // print('what about this?');
      UserOptions option = new UserOptions(option_ids![0]);
     // print(option.id);
      option_ids?.removeAt(0);

      top3.add( await option.initialize(this.id));
    }

   // print("Adding");
  }

  get_option(){
    if(top3.length > 0) {
      UserOptions option = top3[0];
      top3.removeAt(0);

      return option;
    }
  }

  update_option() async {
    top3.removeAt(0);

    UserOptions option = new UserOptions(option_ids![0]);
    option_ids?.removeAt(0);
    top3.add(await option.initialize(this.id));

    notifyListeners();
    return option;

  }

  update_encountered(String id) async {

    encountered_ids?[id] = id;
    await _fb.set_encountered(this.id, id);
  }

  update_right(String id) {
    _fb.set_right(this.id, id);
  }

  update_left(String id){

    _fb.set_left(this.id, id);
  }

  update_match(String id){

    matches?.add(id);
    _fb.set_matches(this.id, id);
    //print(matches);
  }

  start_chat(String id){
    _fb.start_chat(this.id, id);
  }




  printing(){
    print(id);
    print(required);
    print(images);
    print(optional);
    print(matches);
  }


/**
 *  Flow ->
 *  get the unique id of the user
 *  use map and snapshot to fetch the data from the database and store it in instance
 *  create a new class to made it easy to fetch docs
 *
 */

}