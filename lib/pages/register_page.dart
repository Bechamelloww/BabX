import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babx/components/my_button.dart';
import 'package:babx/components/my_textfield.dart';
import 'package:babx/components/square_tile.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();


  // sign user in method
  void signUserUp() async {

    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        // add user details
        FirebaseFirestore.instance.collection('users').doc(userCredential.user!.email).set({
          'email' : emailController.text,
          'username' : usernameController.text,
          'firstname' : firstNameController.text,
          'lastname' : lastNameController.text,
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
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(
          message,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),),
        backgroundColor: Colors.black,
      );
    });
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

              // welcome back, you've been missed!
              const Text(
                'Inscris-toi !',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 25),

              // email textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Nom d\'utilisateur',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // email textfield
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

              // sign in button
              MyButton(
                onTap: signUserUp,
                text: "S'inscrire",
              ),

              const SizedBox(height: 30),

              // or continue with
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

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(
                      imagePath: 'assets/images/google.png', onTap: () => AuthService().signInWithGoogle()),
                ],
              ),

              const SizedBox(height: 30),

              // not a member? register now
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