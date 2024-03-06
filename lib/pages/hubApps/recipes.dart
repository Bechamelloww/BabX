import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecipeCreatorPage(),
    );
  }
}

class RecipeCreatorPage extends StatefulWidget {
  const RecipeCreatorPage({Key? key}) : super(key: key);

  @override
  _RecipeCreatorPageState createState() => _RecipeCreatorPageState();
}

class _RecipeCreatorPageState extends State<RecipeCreatorPage> {
  TextEditingController _recipeNameController = TextEditingController();
  TextEditingController _personsController = TextEditingController();
  List<String> _ingredientsList = [];
  List<String> _quantitiesList = [];
  List<String> _utensilsList = [];
  List<String> _instructionsList = [];
  File? _recipeImage;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _recipeImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveRecipe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> savedRecipes =
        prefs.getStringList('recipes')?.map((json) => Map<String, dynamic>.from(jsonDecode(json)))?.toList() ?? [];

    Map<String, dynamic> recipeData = {
      'recipeName': _recipeNameController.text,
      'ingredients': _ingredientsList,
      'persons': _personsController.text,
      'quantities': _quantitiesList,
      'utensils': _utensilsList,
      'instructions': _instructionsList,
    };

    savedRecipes.add(recipeData);
    prefs.setStringList('recipes', savedRecipes.map((json) => jsonEncode(json)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: _recipeImage != null
                    ? Image.file(
                  _recipeImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 150,
                  width: 150,
                  color: Colors.grey[200],
                  child: Icon(Icons.add_a_photo, size: 40),
                ),
              ),
              TextField(
                controller: _recipeNameController,
                decoration: InputDecoration(labelText: 'Recipe Name'),
              ),
              TextField(
                controller: _personsController,
                decoration: InputDecoration(
                  labelText: 'Number of Persons',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              _buildDynamicList(_ingredientsList, 'Ingredients'),
              _buildDynamicList(_quantitiesList, 'Quantities'),
              _buildDynamicList(_utensilsList, 'Utensils'),
              _buildNumberedList(_instructionsList, 'Instructions'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveRecipe();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Recipe Saved'),
                    ),
                  );
                },
                child: Text('Save Recipe'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SavedRecipesPage()),
                  );
                },
                child: Text('View Saved Recipes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicList(List<String> list, String label, {bool isMultiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(label),
        ),
        Column(
          children: list.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: item),
                    onChanged: (value) => item = value,
                    decoration: InputDecoration(
                      hintText: 'Add ${label.substring(0, label.length - 1)}',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    setState(() {
                      list.removeAt(index);
                    });
                  },
                ),
              ],
            );
          }).toList(),
        ),
        IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: () {
            setState(() {
              list.add('');
            });
          },
        ),
      ],
    );
  }

  Widget _buildNumberedList(List<String> list, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(label),
        ),
        Column(
          children: list.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;
            return Row(
              children: [
                Text('${index + 1}.'),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: item),
                    onChanged: (value) => item = value,
                    decoration: InputDecoration(
                      hintText: 'Add ${label.substring(0, label.length - 1)}',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    setState(() {
                      list.removeAt(index);
                    });
                  },
                ),
              ],
            );
          }).toList(),
        ),
        IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: () {
            setState(() {
              list.add('');
            });
          },
        ),
      ],
    );
  }
}

class SavedRecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getSavedRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No saved recipes'),
            );
          } else {
            List<Map<String, dynamic>> savedRecipes = snapshot.data!;
            return ListView.builder(
              itemCount: savedRecipes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(_formatRecipe(savedRecipes[index])),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getSavedRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedRecipesJson = prefs.getStringList('recipes') ?? [];
    return savedRecipesJson.map((json) => Map<String, dynamic>.from(jsonDecode(json))).toList();
  }

  String _formatRecipe(Map<String, dynamic> recipe) {
    return '''
      Recipe Name: ${recipe['recipeName']}
      Ingredients: ${recipe['ingredients'].join(', ')}
      Persons: ${recipe['persons']}
      Quantities: ${recipe['quantities'].join(', ')}
      Utensils: ${recipe['utensils'].join(', ')}
      Instructions: ${recipe['instructions'].asMap().entries.map((entry) => '${entry.key + 1}. ${entry.value}').join('\n')}
    ''';
  }
}
