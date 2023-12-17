import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Ingredient> coursesList = [];
  TextEditingController customIngredientController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Charger la liste des courses depuis les préférences partagées
    _loadCoursesList();
  }

  _loadCoursesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coursesList = prefs.getStringList('coursesList')?.map((ingredient) => Ingredient(name: ingredient))?.toList() ?? [];
    });
  }

  _saveCoursesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ingredients = coursesList.map((ingredient) => ingredient.name).toList();
    prefs.setStringList('coursesList', ingredients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: coursesList.length + 1,
        itemBuilder: (context, index) {
          if (index == coursesList.length) {
            return _buildAddCustomIngredientItem();
          } else {
            return _buildCourseItem(coursesList[index]);
          }
        },
      ),
    );
  }

  Widget _buildCourseItem(Ingredient ingredient) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          ingredient.name,
          style: ingredient.isBought
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: ingredient.isBought,
              onChanged: (value) {
                setState(() {
                  ingredient.isBought = value!;
                });
                _saveCoursesList(); // Sauvegarder la liste après la modification
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  coursesList.remove(ingredient);
                });
                _saveCoursesList(); // Sauvegarder la liste après la suppression
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCustomIngredientItem() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: TextField(
          controller: customIngredientController,
          decoration: InputDecoration(
            hintText: 'Ajouter un ingrédient',
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              String customIngredient = customIngredientController.text.trim();
              if (customIngredient.isNotEmpty) {
                coursesList.add(Ingredient(name: customIngredient));
                customIngredientController.clear();
              }
            });
            _saveCoursesList(); // Sauvegarder la liste après l'ajout
          },
        ),
      ),
    );
  }
}

class Ingredient {
  final String name;
  bool isBought;

  Ingredient({required this.name, this.isBought = false});
}
