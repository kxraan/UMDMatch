import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lib/screens/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lib/screens/splash.dart';




import '../screens/swipe.dart';
import '../screens/authentication/auth.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children:  [
            Header(),
            CardsStackWidget(),
          ],
        ),
      ),
    );
  }
}

class Profile {
  const Profile({
    required this.name,
    required this.image1,
    required this.image2,
    required this.age,
    required this.sex,
    required this.genderpref,
    required this.major,
  });
  final String name;
  final String image1;
  final String image2;
  final String age;
  final String sex;
  final String genderpref;
  final String major;
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key, required this.profile}) : super(key: key);
  final Profile profile;



  @override
  Widget build(BuildContext context) {
    return Container(
     // borderRadius: BorderRadius.circular(10),
      height: 680,
      width: 340,
      padding: const EdgeInsets.fromLTRB(0, 40, 00, 00),

      child: ListView(

        children: [

          Container(
            //height: 680,
           // padding: const EdgeInsets.fromLTRB(0, 0, 00, 15),
            child: Column(
            children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
                //constraints: BoxConstraints(),
                child: Stack(
                  //fit: BoxFit.fitHeight,
                children: <Widget>[
                  Image.network(
                  (profile.image1),
                  fit: BoxFit.fitHeight,

                ),
                  Container(
                    //padding: const EdgeInsets.only(top: 30),

                  /*  height: 580,
                   width: 340,
                    alignment: Alignment.topLeft,
                    decoration: ShapeDecoration(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      shadows: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),*/

                    //child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 380),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  profile.name,
                                  textAlign:TextAlign.end,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 32,

                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(right: 10.0),),
                                Text(
                                  profile.age,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 30,
                                  ),
                                ),
                              ]
                          ),
                          Text(
                            profile.major,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 27,
                            ),
                          ),
                        ],
                      ),
                    ),
                 // ),
    ]
                ),
            ),
    ]
            ),
          ),

          Container(
            //padding: const EdgeInsets.only(top: 30),

             height: 80,
                   width: 340,
                    alignment: Alignment.topLeft,
                    decoration: ShapeDecoration(
                      color: Colors.red.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      shadows: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),

            //child: Padding(
            padding: const EdgeInsets.only(left: 20, ),

            child: Text(
              //crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,



                //Text(
                  profile.sex,
              textAlign: TextAlign.center,
              style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 21,

                  ),
               // ),

            ),
          ),


          Container(
            child:
            ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child:Image.network(
                  (profile.image2),
                  fit: BoxFit.fitHeight,
                )
            ),
          ),

        ],
      ),
    );
  }
}

enum Swipe { left, right, none }

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget(
      {Key? key, required this.onPressed, required this.icon})
      : super(key: key);
  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
        ),
        child: IconButton(onPressed: onPressed, icon: icon),
      ),
    );
  }
}

class DragWidget extends StatefulWidget {
   DragWidget({
    Key? key,
    required this.profile,
    required this.index,
    required this.swipeNotifier,
    this.isLastCard = false,
  }) : super(key: key);
  final Profile profile;
  final int index;
  final ValueNotifier<Swipe> swipeNotifier;
  final bool isLastCard;
  double? pos;

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Draggable<int>(
        // Data is the value this Draggable stores.
        axis: Axis.horizontal,
        data: widget.index,
        feedback: Material(
          color: Colors.transparent,
          child: ValueListenableBuilder(
            valueListenable: widget.swipeNotifier,
            builder: (context, swipe, _) {
              return RotationTransition(
                turns: widget.swipeNotifier.value != Swipe.none
                    ? widget.swipeNotifier.value == Swipe.left
                    ?  AlwaysStoppedAnimation(widget.pos! / 360)
                    :  AlwaysStoppedAnimation(widget.pos!/ 360)
                    : const AlwaysStoppedAnimation(0),
                child: Stack(
                  children: [
                    ProfileCard(profile: widget.profile),
                    widget.swipeNotifier.value != Swipe.none
                        ? widget.swipeNotifier.value == Swipe.right
                        ? Positioned(
                      top: 40,
                      left: 20,
                      child: Transform.rotate(
                        angle: 12,
                        child: TagWidget(
                          text: 'LIKE',
                          color: Colors.green[400]!,
                        ),
                      ),
                    )
                        : Positioned(
                      top: 50,
                      right: 24,
                      child: Transform.rotate(
                        angle: -12,
                        child: TagWidget(
                          text: 'DISLIKE',
                          color: Colors.red[400]!,
                        ),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ),
        onDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          if (dragUpdateDetails.delta.dx > 0 &&
              dragUpdateDetails.globalPosition.dx >
                  MediaQuery.of(context).size.width / 2) {
            widget.swipeNotifier.value = Swipe.right;
            widget.pos= dragUpdateDetails.delta.dx;
          }
          if (dragUpdateDetails.delta.dx < 0 &&
              dragUpdateDetails.globalPosition.dx <
                  MediaQuery.of(context).size.width / 2) {
            widget.swipeNotifier.value = Swipe.left;
            widget.pos= dragUpdateDetails.delta.dx;
          }
        },
        onDragEnd: (drag) {
          widget.swipeNotifier.value = Swipe.none;
        },

        childWhenDragging: Container(
          color: Colors.transparent,
        ),

        //This will be visible when we press action button
        child: ValueListenableBuilder(
            valueListenable: widget.swipeNotifier,
            builder: (BuildContext context, Swipe swipe, Widget? child) {
              return Stack(
                children: [
                  ProfileCard(profile: widget.profile),
                  // heck if this is the last card and Swipe is not equal to Swipe.none
                  swipe != Swipe.none && widget.isLastCard
                      ? swipe == Swipe.right
                      ? Positioned(
                    top: 40,
                    left: 20,
                    child: Transform.rotate(
                      angle: 12,
                      child: TagWidget(
                        text: 'LIKE',
                        color: Colors.green[400]!,
                      ),
                    ),
                  )
                      : Positioned(
                    top: 50,
                    right: 24,
                    child: Transform.rotate(
                      angle: -12,
                      child: TagWidget(
                        text: 'DISLIKE',
                        color: Colors.red[400]!,
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              );
            }),
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: color,
            width: 4,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 36,
        ),
      ),
    );
  }
}

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({Key? key}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget>
    with SingleTickerProviderStateMixin {

  fakeAcc() async {

    for(var i=0; i<=25; i++){
      await FirebaseFirestore.instance
          .collection('users')
          .doc('test$i')
          .set({'email' : 'test$i@gmail.com'}, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc('test$i').collection('profile').doc('required')
          .set({'name' : 'test$i'}, SetOptions(merge: true));

      DateTime dobDate = DateTime.parse('2003-02-01');
      await FirebaseFirestore.instance
          .collection('users')
          .doc('test$i').collection('profile').doc('required').
      set({'dob': Timestamp.fromDate(dobDate)}, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc('test$i').collection('profile').doc('required').
      set({'major': 'Computer Science'}, SetOptions(merge: true));

      if(i%2==0) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc('test$i').collection('profile').doc('required').
        set({'gender': 'Male'}, SetOptions(merge: true));

        await FirebaseFirestore.instance
            .collection('users')
            .doc('test$i').collection('profile').doc('required').
        set({'gender_pref': 'Female'}, SetOptions(merge: true));

        await FirebaseFirestore.instance.collection('Male').doc('test$i').set({'id': 'test$i'});

      }else{
        await FirebaseFirestore.instance
            .collection('users')
            .doc('test$i').collection('profile').doc('required').
        set({'gender': 'Female'}, SetOptions(merge: true));

        await FirebaseFirestore.instance
            .collection('users')
            .doc('test$i').collection('profile').doc('required').
        set({'gender_pref': 'Male'}, SetOptions(merge: true));

        await FirebaseFirestore.instance.collection('Female').doc('test$i').set({'id': 'test$i'});
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc('test$i').collection('profile').doc('images')
          .set({'Img 1': 'https://firebasestorage.googleapis.com/v0/b/umd-match.appspot.com/o/images%2F1690397034111.jpg?alt=media&token=c9becec2-eac8-4711-962d-bec6e7018dbf'},  SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc('test$i').collection('profile').doc('images')
          .set({'Img 2': 'https://firebasestorage.googleapis.com/v0/b/umd-match.appspot.com/o/images%2F1690397034180.jpg?alt=media&token=ca39d4c3-1cc2-4628-8acf-208e20644f41'},  SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc('test$i').collection('profile').doc('images')
          .set({'Img 3': 'https://firebasestorage.googleapis.com/v0/b/umd-match.appspot.com/o/images%2F1690397034183.jpg?alt=media&token=c91b2de3-a0b2-4523-bfa9-dd10f062dde5'},  SetOptions(merge: true));

        print("Completed $i");
    }

  }

  deleteFakeACC() async {
    for(var i =3; i<=25; i++){
      await FirebaseFirestore.instance
          .collection('users')
          .doc('test$i').delete();
    }
  }

  List<Profile> draggableItems = [

    /*const Profile(
      name: 'Zoyah',
      imageAsset: 'https://firebasestorage.googleapis.com/v0/b/umd-match.appspot.com/o/images%2F1690397034111.jpg?alt=media&token=c9becec2-eac8-4711-962d-bec6e7018dbf',
      age: "19",
      sex: "Female",
      genderpref: "male",
    ),*/
  ];

  Future<List<Profile>> initialize() async {

    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email;
    var match = RegExp('([a-z]+)').firstMatch(email!);
    String? userId = match?.group(0);

    var gender_user =  await FirebaseFirestore.instance.collection('users').doc(userId).collection('profile').doc('required');
    var gen = await gender_user.get();
    var gend = gen.data();
    print(gend);
    var gender = (gend?['gender_pref']);
    
  CollectionReference ref  =  FirebaseFirestore.instance.collection(gender);
  QuerySnapshot users = await ref.get();

  List<String> userIds = [];
    for(DocumentSnapshot doc in users.docs){
      userIds.add(doc.get('id'));
    }

    CollectionReference ref1 = FirebaseFirestore.instance.collection('users');
   // QuerySnapshot users1 = await ref1.get();


  for (String id in userIds) {
    DocumentSnapshot document = await ref1.doc(id).get();
    //print(document.id);
    CollectionReference profile = document.reference.collection('profile');
    var required = await profile.doc('required').get();
    var img = await profile.doc('images').get();

    var days = DateTime.now().difference(required.get('dob').toDate()).inDays;
    var age = days ~/360;
    //print(img.get('Img 1'));
    draggableItems.add(
         Profile(
          name: required.get('name'),
          image1: (img.get('Img 1')),
          image2: img.get('Img 2'),
          age: '$age',
          sex: required.get('gender'),
          genderpref: required.get('gender_pref'),
           major: required.get('major'),

        )
    );
  }
  return draggableItems;
  }





  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    //deleteFakeACC();
   // fakeAcc();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
     initialize().then((value) {
       setState(() {
          //draggableItems = value;
       });
     });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        draggableItems.removeLast();
        _animationController.reset();

        swipeNotifier.value = Swipe.none;
      }
    });
  }

  @override
  Widget build(BuildContext context) {



    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ValueListenableBuilder(
            valueListenable: swipeNotifier,
            builder: (context, swipe, _) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: List.generate(draggableItems.length, (index) {
                if (index == draggableItems.length - 1) {
                  return PositionedTransition(
                    rect: RelativeRectTween(
                      begin: RelativeRect.fromSize(
                          const Rect.fromLTWH(0, 0, 580, 340),
                          const Size(580, 340)),
                      end: RelativeRect.fromSize(
                          Rect.fromLTWH(
                              swipe != Swipe.none
                                  ? swipe == Swipe.left
                                  ? -300
                                  : 300
                                  : 0,
                              0,
                              580,
                              340),
                          const Size(580, 340)),
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    )),
                    child: RotationTransition(
                      turns: Tween<double>(
                          begin: 0,
                          end: swipe != Swipe.none
                              ? swipe == Swipe.left
                              ? -0.1 * 0.3
                              : 0.1 * 0.3
                              : 0.0)
                          .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve:
                          const Interval(0, 0.4, curve: Curves.easeInOut),
                        ),
                      ),
                      child: DragWidget(
                        profile: draggableItems[index],
                        index: index,
                        swipeNotifier: swipeNotifier,
                        isLastCard: true,
                      ),
                    ),
                  );
                } else {
                  return DragWidget(
                    profile: draggableItems[index],
                    index: index,
                    swipeNotifier: swipeNotifier,
                  );
                }
              }),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 46.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButtonWidget(
                  onPressed: () {
                    swipeNotifier.value = Swipe.left;
                    _animationController.forward();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 20),
                ActionButtonWidget(
                  onPressed: () {
                    swipeNotifier.value = Swipe.right;
                    _animationController.forward();
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: DragTarget<int>(
            builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
                ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              setState(() {
                draggableItems.removeAt(index);
              });
            },
          ),
        ),
        Positioned(
          right: 0,
          child: DragTarget<int>(
            builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
                ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              setState(() {
                draggableItems.removeAt(index);
              });
            },
          ),
        ),

      ],
    );
  }
}




