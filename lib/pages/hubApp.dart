import 'package:flutter/material.dart';

import 'hubApps/courses.dart';
import 'hubApps/recipes.dart';

class HubAppPage extends StatelessWidget {
  final String appName;
  final String logoPath;

  const HubAppPage(this.appName, this.logoPath, {Key? key}) : super(key: key);

  Widget _buildAppContent() {
    switch (appName) {
      case 'Recettes':
        return const RecipeCreatorPage();
      case 'Liste de courses':
       return const CoursesPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName, style: const TextStyle(
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
      ),
      body: Center(
        child: _buildAppContent(),
      ),
    );
  }
}



// Ajoutez d'autres classes pour chaque application si nécessaire
// class AutreApplicationPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Contenu de l\'Autre Application'),
//     );
//   }
// }
