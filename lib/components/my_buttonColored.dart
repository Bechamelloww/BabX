import 'package:flutter/material.dart';

class MyButtonColored extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color color;

  const MyButtonColored({super.key, required this.onTap, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
