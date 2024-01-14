import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../screens/wrapper.dart';
import 'database_source.dart';

class UserOptions{

  String id ='';
  Map<String, dynamic> required= {};
  Map<String, dynamic> images = {};
  Map<String, dynamic> right = {};
  bool match = false;
  //List<Completer<ImageInfo>>? completer;
  List<ImageInfo>? image_infos;
  List<ImageProvider> image_providers =[];

  FirebaseDatabase _fb = new FirebaseDatabase();

  UserOptions(String id){
    this.id = id;
  }

  initialize(String userId) async {
    this.required = (await _fb.get_required(this.id)).data();
    this.images = ( await _fb.get_images(this.id)).data();

    await loadImages();
   // print('here');
    this.right = await  _fb.get_right(this.id);
    //print(right);
    match = right.containsKey('('+userId+')');
   // print(match);
    return this;
  }

  evict_images(){
    for(var provider in image_providers){
      try {
        provider.evict();
      }catch(e){
        print('Image removal failed: '+ e.toString());
      }
    }
  }


  Future<void> loadImages() async {
    try {

      for(var image in images.values){
        image_providers.add(NetworkImage(image));
      }
      List<Future<ImageInfo>> imageFutures = image_providers.map(loadImage).toList();
      image_infos = await Future.wait(imageFutures);
      // Now you have a list of ImageInfo objects
      // Do something with the loaded images
    } catch (e) {
      // Handle errors
      print(e);
    }
  }

  Future<ImageInfo> loadImage(ImageProvider provider) {
    Completer<ImageInfo> completer = Completer();
    late ImageStreamListener listener;
    listener = ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
        completer.complete(image);
        provider.resolve(ImageConfiguration.empty).removeListener(listener);
      },
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace);
      },
    );
    provider.resolve(ImageConfiguration.empty).addListener(listener);
    return completer.future;
  }



  @override
  String toString() {
    String ans = id + '\n';
    return ans;
  }



}