import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib/screens/wrapper.dart';
import 'package:video_player/video_player.dart';

import 'authentication/sign_in.dart';

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

    ..initialize().then((_SplashScreenState) {
      setState(() {

      });
    })
    ..setVolume(0.0);

    _playVideo();
    Timer(Duration(seconds: 5),(){
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
      // body: Container(
      //   color: Colors.redAccent,
      //   child: Center(child: Text('UMD MATCH',style: TextStyle(
      //     fontSize: 36,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //
      //   ),
      //   ),
      //   ),
      //
      // ),
    );
  }
}