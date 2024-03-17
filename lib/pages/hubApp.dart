import 'package:babx/pages/BabyfootLobbyPage.dart';
import 'package:flutter/material.dart';

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
                  width: 40.0,
                  height: 40.0,
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
      case 'Jean-Macé 1':
        return BabyfootLobbyPage(appName);
      case 'Jean-Macé 2':
        return BabyfootLobbyPage(appName);
      case 'Perrache 1':
        return BabyfootLobbyPage(appName);
      case 'Perrache 2':
        return BabyfootLobbyPage(appName);
      default:
        return Container();
    }
  }
}
