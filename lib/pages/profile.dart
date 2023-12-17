import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  GoogleSignInAccount? _googleUser;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    GoogleSignInAccount? user = _googleSignIn.currentUser;

    if (user == null) {
      // L'utilisateur n'est pas connecté, afficher le bouton de connexion
      await _handleSignIn();
    } else {
      // L'utilisateur est connecté, mettre à jour l'état
      setState(() {
        _googleUser = user;
      });
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      _checkCurrentUser();
    } catch (error) {
      print('Erreur de connexion avec Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _googleUser == null
            ? ElevatedButton(
          onPressed: _handleSignIn,
          child: Text('Se connecter avec Google'),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_googleUser?.photoUrl ?? ''),
            ),
            SizedBox(height: 16),
            Text('Bienvenue, ${_googleUser?.displayName ?? 'Utilisateur'}'),
          ],
        ),
      ),
    );
  }
}
