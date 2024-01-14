

import 'package:flutter/material.dart';

class Portrait extends StatelessWidget {
  final ImageInfo imageInfo;
  final double height;

  Portrait({required this.imageInfo, this.height = 225.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.height * 0.65,
      height: height,
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Color(0xFFF4C470)),
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.0),
        child:
            RawImage(
          image: imageInfo.image,
          fit: BoxFit.fitHeight,
        )

      ),
    );
  }
}
