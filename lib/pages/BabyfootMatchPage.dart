import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BabyfootMatchPage extends StatefulWidget {
  final String matchId;

  const BabyfootMatchPage(this.matchId, {Key? key}) : super(key: key);

  @override
  _BabyfootMatchPageState createState() => _BabyfootMatchPageState();
}

class _BabyfootMatchPageState extends State<BabyfootMatchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference matchDoc;

  @override
  void initState() {
    super.initState();
    matchDoc = _firestore.collection('matches').doc(widget.matchId);
  }

  Future<void> _updateScore(String team, int score) async {
    await matchDoc.update({
      '${team}_score': FieldValue.increment(score),
    });

    final matchSnapshot = await matchDoc.get();
    final matchData = matchSnapshot.data() as Map<String, dynamic>?;
    if (matchData != null && matchData['${team}_score'] >= 10) {
      await matchDoc.update({
        'winner': team == 'blue' ? 2 : 3,
      });
      await _createNewMatch();
      Navigator.pop(context);
    }
  }

  Future<void> _createNewMatch() async {
    await _firestore.collection('matches').add({
      'blue_score': 0,
      'red_score': 0,
      'blue_player_1': null,
      'blue_player_2': null,
      'red_player_1': null,
      'red_player_2': null,
      'winner': null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match en cours', style: TextStyle(fontWeight: FontWeight.bold,
            color: Colors.white70)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: matchDoc.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final matchData = snapshot.data!.data() as Map<String, dynamic>?;

          if (matchData == null) {
            return const Center(child: Text('Aucune donnée disponible'));
          }

          return Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${matchData['blue_score']}',
                        style: const TextStyle(
                          fontSize: 100,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${matchData['blue_player_1'] ?? 'Vide'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${matchData['blue_player_2'] ?? 'Vide'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${matchData['red_score']}',
                        style: const TextStyle(
                          fontSize: 100,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${matchData['red_player_1'] ?? 'Vide'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${matchData['red_player_2'] ?? 'Vide'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _updateScore('blue', 1),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _updateScore('red', 1),
            backgroundColor: Colors.red,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
