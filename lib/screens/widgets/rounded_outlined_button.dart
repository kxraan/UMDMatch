import 'package:flutter/material.dart';

class RoundedOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Changed type to VoidCallback?

  RoundedOutlinedButton({required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(text, style: Theme.of(context).textTheme.button),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            side: BorderSide(color: Colors.white, width: 2.0),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (states) {
                if (states.contains(MaterialState.pressed))
                  return Color(0xFFF4C470).withOpacity(0.12); // Custom opacity as an example
                if (states.contains(MaterialState.hovered))
                  return Color(0xFFF4C470).withOpacity(0.04);
                return null; // Defer to the widget's default.
              },
            ),
          ),
        )

    );
  }
}
