import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;
    if (user != null) {
      if (userCredential.additionalUserInfo!.isNewUser) {
        final List<String> nameParts = user.displayName!.split(" ");
        String firstName = nameParts.first;
        String lastName = nameParts.length > 1 ? nameParts.last.toUpperCase() : '';
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .set({
          'uid': user.uid,
          'img_url': user.photoURL,
          'email': user.email,
          'username': user.displayName,
          'firstname': firstName,
          'lastname': lastName.toUpperCase(),
          'fav_babyfoot': "Aucun",
          'fav_mate': "Aucun",
          'total_opponents': 0,
          'total_games': 0,
          'wins': 0,
          'loss': 0,
          'gamestyle': 'Débutant',
          'nb_goals': 0,
          'nb_conceded': 0,
        });
      }
    }
  }
}
