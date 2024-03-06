import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'hub.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900], // Changer ici pour la couleur de fond souhaitée
      child: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text(
              "BabX",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Center(
              child: Text("Connecté en tant que ${user!.email!}",
              style: TextStyle(
                  color: Colors.white60
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
