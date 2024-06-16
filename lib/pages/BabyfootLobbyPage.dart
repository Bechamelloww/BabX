import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BabyfootLobbyPage extends StatelessWidget {
  final String babyfootName;

  const BabyfootLobbyPage(this.babyfootName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .doc(babyfootName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final matchData = snapshot.data!.data() as Map<String, dynamic>;
          final int winner = matchData['winner'] ?? 0;
          final bool gameInProgress = winner == 1;

          if (gameInProgress) {
            return _buildGameInProgressUI(matchData);
          } else {
            return _buildJoinTeamUI(matchData);
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildJoinTeamUI(Map<String, dynamic> matchData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            await _joinTeam(matchData['babyfootName'], 'blue'); // Rejoindre les bleus
          },
          child: const Text('Rejoindre les bleus'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _joinTeam(matchData['babyfootName'], 'red'); // Rejoindre les rouges
          },
          child: const Text('Rejoindre les rouges'),
        ),
      ],
    );
  }

  Widget _buildGameInProgressUI(Map<String, dynamic> matchData) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Afficher les noms des joueurs par équipe, les scores, etc.
        Text('Partie en cours'),
      ],
    );
  }

  Future<void> _joinTeam(String babyfootName, String teamColor) async {
    final matchesRef = FirebaseFirestore.instance.collection('matches');

    // Vérifier s'il y a déjà un match en cours pour ce babyfoot
    final existingMatch = await matchesRef
        .where('babyfootName', isEqualTo: babyfootName)
        .where('winner', whereIn: [0, 1]) // 0 ou 1 signifie qu'un match est en cours ou en attente
        .get();

    if (existingMatch.docs.isEmpty) {
      // S'il n'y a pas de match en cours, créer un nouveau match
      await matchesRef.add({
        'babyfootName': babyfootName,
        'winner': 0, // Mettre la valeur de winner à 0 pour indiquer un match en cours de création
      });
    }

    // Rejoindre l'équipe spécifiée (bleue ou rouge) - à implémenter
  }
}
