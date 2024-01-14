import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../authentication/sign_in.dart';
import '../wrapper.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/UMDMatchfinal.mp4')

    ..initialize().then((_) {
      setState(() {

      });
    })
    ..setVolume(0.0);

    //_playVideo();
    _controller.play();
    Timer(Duration(seconds: 5),(){
      if(mounted)
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Wrapper(),));
    });
  }
  void _playVideo() async {
    _controller.play();

    await Future.delayed(const Duration(seconds: 10));
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Wrapper(),));
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(
              _controller,
            ),
        )
        : Container(),

      ),
    );
  }
}