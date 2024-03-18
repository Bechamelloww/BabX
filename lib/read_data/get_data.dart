import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  static Future<String?> getUserNameFromEmail() async {
    String? userMail = FirebaseAuth.instance.currentUser?.email;
    if (userMail != null) {
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userMail)
          .get();
      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData =
            userDataSnapshot.data() as Map<String, dynamic>;
        return userData['username'];
      }
    }
    return null;
  }

  static Future<String?> getLastNameFromEmail() async {
    String? userMail = FirebaseAuth.instance.currentUser?.email;
    if (userMail != null) {
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userMail)
          .get();
      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData =
        userDataSnapshot.data() as Map<String, dynamic>;
        return userData['lastname'];
      }
    }
    return null;
  }

  static Future<String?> getFirstNameFromEmail() async {
    String? userMail = FirebaseAuth.instance.currentUser?.email;
    if (userMail != null) {
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userMail)
          .get();
      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData =
        userDataSnapshot.data() as Map<String, dynamic>;
        return userData['firstname'];
      }
    }
    return null;
  }
}

Future<void> updateImageUrl(String imageUrl) async {
  try {
    String? userMail = FirebaseAuth.instance.currentUser?.email;
    if (userMail != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userMail)
          .update({'img_url': imageUrl});
      print('Image URL updated successfully.');
    } else {
      print('No user signed in.');
    }
  } catch (error) {
    print('Error updating image URL: $error');
  }
}


class UsernameText extends StatelessWidget {
  const UsernameText({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: UserDataService.getUserNameFromEmail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data != null) {
            return Text(
              "Connecté en tant que ${snapshot.data!} !",
              style: const TextStyle(color: Colors.white60),
            );
          } else {
            return const Text('Pas de nom d\'utilisateur trouvé');
          }
        }
      },
    );
  }
}
