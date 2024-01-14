import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Changed type to VoidCallback?

  RoundedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          primary: Color(0xFFF4C470).withOpacity(onPressed != null ? 1.0 : 0.25), // Button color
          elevation: 0,
        ).copyWith(
          elevation: ButtonStyleButton.allOrNull<double>(0.0), // Override elevation when button is pressed
        ),
      )

    );
  }
}
