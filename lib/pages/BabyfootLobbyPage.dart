import 'package:babx/components/my_BigButtonColored.dart';
import 'package:babx/components/my_button.dart';
import 'package:babx/components/my_buttonColored.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'BabyfootMatchPage.dart';

class BabyfootLobbyPage extends StatefulWidget {
  final String babyfootName;

  const BabyfootLobbyPage(this.babyfootName, {Key? key}) : super(key: key);

  @override
  _BabyfootLobbyPageState createState() => _BabyfootLobbyPageState();
}

class _BabyfootLobbyPageState extends State<BabyfootLobbyPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<DocumentReference> matchDocFuture;
  User? user;
  List<String> waitingPlayers = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    matchDocFuture = _getOrCreateMatch();
  }

  Future<DocumentReference> _getOrCreateMatch() async {
    final querySnapshot = await _firestore
        .collection('matches')
        .where('babyfoot', isEqualTo: widget.babyfootName)
        .where('winner', isEqualTo: 0)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.reference;
    } else {
      return await _firestore.collection('matches').add({
        'babyfoot': widget.babyfootName,
        'blue_player_1': null,
        'blue_player_2': null,
        'blue_score': 0,
        'red_player_1': null,
        'red_player_2': null,
        'red_score': 0,
        'created_at': FieldValue.serverTimestamp(),
        'winner': 0,
      });
    }
  }

  Future<void> _joinTeam(DocumentReference matchDoc, String team) async {
    final doc = await matchDoc.get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final email = user!.email;

      if ([
        data['blue_player_1'],
        data['blue_player_2'],
        data['red_player_1'],
        data['red_player_2']
      ].contains(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vous êtes déjà dans une équipe')));
        return;
      }

      if (data['${team}_player_1'] == null) {
        await matchDoc.update({'${team}_player_1': email});
      } else if (data['${team}_player_2'] == null) {
        await matchDoc.update({'${team}_player_2': email});
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Équipe $team pleine')));
      }

      setState(() {
        waitingPlayers.remove(email);
      });
    }
  }

  Future<void> _removePlayerFromTeam(DocumentReference matchDoc) async {
    final doc = await matchDoc.get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final email = user!.email;
      final updates = <String, dynamic>{};

      if (data['blue_player_1'] == email) {
        updates['blue_player_1'] = null;
      }
      if (data['blue_player_2'] == email) {
        updates['blue_player_2'] = null;
      }
      if (data['red_player_1'] == email) {
        updates['red_player_1'] = null;
      }
      if (data['red_player_2'] == email) {
        updates['red_player_2'] = null;
      }

      if (updates.isNotEmpty) {
        await matchDoc.update(updates);
      }
    }
  }

  Future<void> _startGame(DocumentReference matchDoc) async {
    final doc = await matchDoc.get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final String? bluePlayer1 = data['blue_player_1'] as String?;
      final String? redPlayer1 = data['red_player_1'] as String?;
      if (bluePlayer1 != null && redPlayer1 != null) {
        await matchDoc.update({'winner': 1});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BabyfootMatchPage(matchDoc.id),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erreur'),
            content: Text(
                'Il faut au moins un joueur dans chaque équipe pour commencer la partie.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _joinAsSpectator(DocumentReference matchDoc) async {
    await _removePlayerFromTeam(matchDoc);
    setState(() {
      waitingPlayers.add(user!.email!);
    });
  }

  @override
  void dispose() {
    matchDocFuture.then((matchDoc) => _removePlayerFromTeam(matchDoc));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentReference>(
        future: matchDocFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final matchDoc = snapshot.data!;
          return StreamBuilder<DocumentSnapshot>(
            stream: matchDoc.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data!.data() as Map<String, dynamic>;
              final List<String?> allPlayers = [
                data['blue_player_1'] as String?,
                data['blue_player_2'] as String?,
                data['red_player_1'] as String?,
                data['red_player_2'] as String?,
              ];
              final email = user!.email;
              final bool isBluePlayer = allPlayers.contains(email) &&
                  (data['blue_player_1'] == email ||
                      data['blue_player_2'] == email);
              final bool isRedPlayer = allPlayers.contains(email) &&
                  (data['red_player_1'] == email ||
                      data['red_player_2'] == email);
              final bool isSpectator = !isBluePlayer && !isRedPlayer;
              return Center(
                child: Column(
                  children: [
                    Text('Équipe Bleue:'),
                    Text('Joueur 1: ${data['blue_player_1'] ?? 'Vide'}'),
                    Text('Joueur 2: ${data['blue_player_2'] ?? 'Vide'}'),
                    if (!isBluePlayer)
                      MyButtonColored(
                        onTap: () => _joinTeam(matchDoc, 'blue'),
                        text: "Rejoindre l'équipe bleue",
                        color: Colors.blue,
                      ),
                    const SizedBox(height: 50,),
                    Text('Équipe Rouge:'),
                    Text('Joueur 1: ${data['red_player_1'] ?? 'Vide'}'),
                    Text('Joueur 2: ${data['red_player_2'] ?? 'Vide'}'),
                    if (!isRedPlayer)
                      MyButtonColored(
                        onTap: () => _joinTeam(matchDoc, 'red'),
                        text: "Rejoindre l'équipe rouge",
                        color: Colors.red,
                      ),
                    if (!isSpectator)
                      ElevatedButton(
                        onPressed: () => _joinAsSpectator(matchDoc),
                        child: Text('Rejoindre les Spectateurs'),
                      ),
                    Text('En attente:'),
                    Column(
                      children: waitingPlayers
                          .where((player) => !allPlayers.contains(player))
                          .map((player) => Text(player!))
                          .toList(),
                    ),
                    const SizedBox(height: 350,),
                    FractionallySizedBox(
                      widthFactor: 0.85,
                      child: MyBigButtonColored(
                        onTap: () => _startGame(matchDoc),
                        text: 'Commencer la Partie',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
