import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:babx/pages/main_page.dart';
import 'package:babx/pages/login_page.dart';

import 'Home.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const Home();
          } else {
            return const LoginOrRegisterPage();
          }
        }
      ),
    );
  }
}
