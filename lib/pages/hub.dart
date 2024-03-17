import 'dart:math';
import 'package:flutter/material.dart';
import 'package:babx/pages/hubApp.dart';

class HubPage extends StatelessWidget {
  const HubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildAppTile(context, 'Jean-Macé 1', 'assets/images/jmacebaby.jpg'),
            _buildAppTile(context, 'Jean-Macé 2', 'assets/images/jmacebaby.jpg'),
            _buildAppTile(context, 'Perrache 1', 'assets/images/perrache1.jpg'),
            _buildAppTile(context, 'Perrache 2', 'assets/images/perrache2.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTile(BuildContext context, String appName, String logoPath) {
    Random random = Random();

    Color randomColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      splashColor: randomColor.withOpacity(0.1),
      onTap: () {
        Navigator.of(context).push(_createPageRoute(context, appName, logoPath));
      },
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Hero(
          tag: '$appName-$logoPath',
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                logoPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageRouteBuilder _createPageRoute(BuildContext context, String appName, String logoPath) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return HubAppPage(appName, logoPath);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        var curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return ScaleTransition(
          scale: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
