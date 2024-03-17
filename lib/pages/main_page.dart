import 'package:babx/read_data/get_top5Table.dart';
import 'package:babx/read_data/get_username.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                "BabX",
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Center(
                  child: UsernameText()),
              SizedBox(
                height: 60,
              ),
              Center(
                child: Text(
                  "Le Top 5",
                  style: TextStyle(
                      color: Colors.white60,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Expanded(child: GetTop5Table()),
            ],
          ),
        ));
  }
}
