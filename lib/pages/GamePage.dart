import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  final String appName;

  const GamePage({Key? key, required this.appName}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName),
      ),
      body: Center(
        child: Text(
          'Vous jouez sur le babyfoot ${widget.appName}',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
