import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:babx/pages/profile.dart';
import 'chat_page.dart';
import 'main_page.dart';
import 'hub.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: [
            const Text("Home",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),),
            const Text("Hub",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),),
            const Text("Chat",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),),
            const Text("Profil",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),)
          ][_currentIndex],
          actions: [
            IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
          ],
        ),

        body: [
          HomePage(),
          const HubPage(),
          const ChatPage(),
          const ProfilePage(),
        ][_currentIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.red.shade50,
            brightness: Brightness.dark,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) => setCurrentIndex(index),
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            iconSize: 21,
            elevation: 1,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.all_inclusive),
                label: 'Hub',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_sharp),
                label: 'Profil',
              ),
            ],
          ),
        )
    );
  }
}
