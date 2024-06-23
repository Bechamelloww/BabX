import 'package:flutter/material.dart';

class MyBigButtonColored extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color color;

  const MyBigButtonColored({super.key, required this.onTap, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.black),
        minimumSize: WidgetStateProperty.all(const Size(200, 60)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
