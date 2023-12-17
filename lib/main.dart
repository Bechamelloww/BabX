import 'package:flutter/material.dart';
import 'package:recipx/pages/EventPage.dart';
import 'package:recipx/pages/HomePage.dart';
import 'package:recipx/pages/addEventPage.dart';

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
                icon: Icon(Icons.calendar_month),
                label: 'Planning'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Ajouter'
            ),
          ],
        ),
      ),
    );
  }
}
