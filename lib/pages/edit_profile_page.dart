import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Éditer le profil', style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: EditProfileForm(),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({Key? key}) : super(key: key);

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  // Ajoutez les contrôleurs pour les champs de formulaire
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  // Ajoutez une clé pour le formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'Prénom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un prénom';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validez le formulaire
                if (_formKey.currentState!.validate()) {
                  // Ajoutez ici le code pour enregistrer les modifications dans la base de données ou ailleurs
                  // Vous pouvez accéder aux valeurs des champs avec _firstNameController.text et _lastNameController.text
                  // N'oubliez pas de naviguer vers la page précédente après l'édition
                  Navigator.pop(context);
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
