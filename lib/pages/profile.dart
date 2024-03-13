import 'package:flutter/material.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
            ),
            const Positioned(
              top: 60,
              left: 30,
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage('https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'),
                foregroundColor: Colors.black,
                foregroundImage: NetworkImage('https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'),
              ),
            ),
            const Positioned(
              top: 80,
              left: 190,
              child: Column(
                children: [
                  Text(
                    'John',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 110,
              left: 190,
              child: Column(
                children: [
                  Text(
                    'DOE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 10,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 30),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Éditer',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),

                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 210,),
                  Wrap(
                    spacing: 10.0, // Espace horizontal entre les boîtes
                    runSpacing: 10.0, // Espace vertical entre les boîtes
                    children: [
                      Column(
                        children: [
                          buildColoredBox("Victoires", "51", Colors.blueAccent, 150, 170),
                          const SizedBox(height: 10,),
                          buildColoredBox("Parties jouées", "60", Colors.redAccent, 150, 100),
                          const SizedBox(height: 10,),
                          buildColoredBox("Test", "TEST", Colors.orange, 150, 100),

                        ]),
                      Column(
                        children: [
                          buildColoredBox("Partenaire Favori", "Johnny\nDOE", Colors.greenAccent, 170, 130),
                          const SizedBox(height: 10,),
                          buildColoredBox("Adversaires affrontés", "10", Colors.red, 170, 100),
                          const SizedBox(height: 10,),
                          buildColoredBox("Babyfoot Favori", "Perrache n°2", Colors.lime, 170, 140),
                        ],),
                      buildColoredBox("Test", "TEST", Colors.purple, 330, 100)
                    ],
                  ),
                  const SizedBox(height: 50,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildColoredBox(String title, String content, Color color, double width, double height) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(
            color: color,
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}