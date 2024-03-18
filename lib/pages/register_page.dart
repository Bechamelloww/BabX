import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babx/components/my_button.dart';
import 'package:babx/components/my_textfield.dart';
import 'package:babx/components/square_tile.dart';
import 'package:quickalert/quickalert.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.email)
            .set({
          'uid': userCredential.user?.uid,
          'email': emailController.text,
          'username': usernameController.text,
          'firstname': firstNameController.text,
          'lastname': lastNameController.text.toUpperCase(),
          'fav_babyfoot': "Aucun",
          'fav_mate': "Aucun",
          'total_opponents': 0,
          'total_games': 0,
          'wins': 0,
          'loss': 0,
          'winrate': 0.0,
          'gamestyle': 'Débutant',
          'nb_goals': 0,
          'nb_conceded': 0,
        });
      } else {
        showErrorMessage("Mots de passe diffférents");
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'invalid-credential') {
        showErrorMessage("E-mail/mot de passe incorrect(s)");
      } else {
        showErrorMessage(e.code);
      }
    }
  }

  void showErrorMessage(String message) {
    print("No user found");
    QuickAlert.show(
      context: context,
      customAsset: 'assets/images/error.gif',
      type: QuickAlertType.error,
      title: 'Oops...',
      text: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              const Text(
                'Inscris-toi !',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              MyTextField(
                controller: usernameController,
                hintText: 'Nom d\'utilisateur',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: emailController,
                hintText: 'E-mail',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: firstNameController,
                hintText: 'Prénom',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: lastNameController,
                hintText: 'Nom',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Mot de passe',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirmer le mot de passe',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 25),

              MyButton(
                onTap: signUserUp,
                text: "S'inscrire",
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Ou continuer avec',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                      imagePath: 'assets/images/google.png',
                      onTap: () => AuthService().signInWithGoogle()),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Déjà inscrit ?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Connexion',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
