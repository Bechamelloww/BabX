import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../read_data/get_data.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Éditer le profil',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
      body: const EditProfileForm(),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({Key? key}) : super(key: key);

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    UserDataService.getUserNameFromEmail().then((value) {
      usernameController.text = value ?? '';
    });
    UserDataService.getFirstNameFromEmail().then((value) {
      firstNameController.text = value ?? '';
    });
    UserDataService.getLastNameFromEmail().then((value) {
      lastNameController.text = value ?? '';
    });
  }

  final user = FirebaseAuth.instance.currentUser;
  final usersCollection = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);

                        String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('images');
                        Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);

                        try {
                          await referenceImageToUpload
                              .putFile(File(file!.path));
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                          print(imageUrl);
                          updateImageUrl(imageUrl);
                        } catch (error) {}
                      },
                      icon: const Icon(Icons.camera_alt)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom d\'utilisateur',
                    ),
                    style: TextStyle(color: Colors.grey.shade500),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom d\'utilisateur';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                    ),
                    style: TextStyle(color: Colors.grey.shade500),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un prénom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                    ),
                    style: TextStyle(color: Colors.grey.shade500),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await usersCollection.doc(user?.email).update({
                          'username': usernameController.text.trim(),
                          'firstname': firstNameController.text.trim(),
                          'lastname':
                              lastNameController.text.trim().toUpperCase(),
                        });
                        Navigator.pop(context);
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Enregistrer',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
