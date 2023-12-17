import 'package:flutter/material.dart';
import 'package:recipx/pages/hub.dart';
import 'package:recipx/pages/HomePage.dart';
import 'package:recipx/pages/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: [
            Text("Accueil"),
            Text("Planning"),
            Text("Ajouter")
          ][_currentIndex],
        ),
        body: [
          HomePage(),
          EventPage(),
          AddEventPage()
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          enableFeedback: true,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          iconSize: 20,
          elevation: 1,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.all_inclusive),
                label: 'Hub'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_sharp),
                label: 'Profil'
            ),
          ],
        ),
      ),
    );
  }
}
