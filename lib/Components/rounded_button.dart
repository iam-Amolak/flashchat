import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  RoundedButton({super.key, required this.color, required this.text, required this.onPress});

  Color color;
  String text;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 10.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 20.0
          ),
        ),
      ),
    );
  }
}
