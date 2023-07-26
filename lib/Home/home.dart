import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lib/screens/header.dart';
import 'package:firebase_auth/firebase_auth.dart';




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
    required this.imageAsset,
    required this.age,
    required this.sex,
    required this.genderpref,
  });
  final String name;
  final String imageAsset;
  final String age;
  final String sex;
  final String genderpref;

}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key, required this.profile}) : super(key: key);
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 580,
      width: 340,
      padding: const EdgeInsets.fromLTRB(0, 30, 00, 15),

      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                profile.imageAsset,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 80,
              width: 340,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: 21,
                      ),
                    ),

                  ],
                ),
              ),
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

  initialize() async {

    var u = await FirebaseFirestore.instance.collection('users').get();
    var v = u.docs.toString();
    print(v);

  CollectionReference ref  =  FirebaseFirestore.instance.collection('users');
  QuerySnapshot users = await ref.get();

  HashMap<String, Profile> data = new HashMap<String, Profile>();

  for (var document in users.docs) {
    Map<String, dynamic>? d = document.data() as Map<String, dynamic>?;
    print(d);
  }


  }
  List<Profile> draggableItems = [
    const Profile(
        name: 'Irene',
        imageAsset: 'assets/images/karan1.jpg',
        age: "19",
        sex: "Female",
        genderpref: "Male",

    ),
    const Profile(
        name: 'Alice',
        imageAsset: 'assets/images/karan2.jpg',
        age: "19",
        sex: "Female",
        genderpref: "male",
    ),
    const Profile(
      name: 'Karan',
      imageAsset: 'assets/images/karan3.jpg',
      age: "19",
      sex: "Female",
      genderpref: "male",
    ),
    const Profile(
      name: 'Krisha',
      imageAsset: 'assets/images/karan4.jpg',
      age: "19",
      sex: "Female",
      genderpref: "male",
    ),
    const Profile(
      name: 'Zoyah',
      imageAsset: 'assets/images/karan5.jpg',
      age: "19",
      sex: "Female",
      genderpref: "male",
    ),
  ];

  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
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
    initialize();
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




