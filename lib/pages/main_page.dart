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
    return Center(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          const Text("RecipX",
            style: TextStyle(
                fontSize: 40,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Center(
            child: Text("Connnecté en tant que ${user!.email!}"),
          )
        ],
      ),
    );
  }
}