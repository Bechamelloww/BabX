import 'package:flutter/material.dart';

import 'hubApps/courses.dart';
import 'hubApps/recipes.dart';

class HubAppPage extends StatelessWidget {
  final String appName;
  final String logoPath;

  const HubAppPage(this.appName, this.logoPath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Hero(
              tag: '$appName-$logoPath',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  logoPath,
                  width: 40.0, // Ajustez la largeur de l'image selon vos besoins
                  height: 40.0, // Ajustez la hauteur de l'image selon vos besoins
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: _buildAppContent(),
      ),
    );
  }

  Widget _buildAppContent() {
    switch (appName) {
      case 'Recettes':
        return RecipeCreatorPage();
      case 'Liste de courses':
        return const CoursesPage();
      default:
        return Container();
    }
  }
}
