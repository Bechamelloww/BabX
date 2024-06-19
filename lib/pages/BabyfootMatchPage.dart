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
      // Navigate back to the lobby
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match en cours'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: matchDoc.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final matchData = snapshot.data!.data() as Map<String, dynamic>?;

          if (matchData == null) {
            return Center(child: Text('Aucune donnée disponible'));
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Équipe Bleue: ${matchData['blue_score']}'),
              Text('Équipe Rouge: ${matchData['red_score']}'),
              ElevatedButton(
                onPressed: () => _updateScore('blue', 1),
                child: Text('Ajouter 1 point à l\'équipe Bleue'),
              ),
              ElevatedButton(
                onPressed: () => _updateScore('red', 1),
                child: Text('Ajouter 1 point à l\'équipe Rouge'),
              ),
            ],
          );
        },
      ),
    );
  }
}
