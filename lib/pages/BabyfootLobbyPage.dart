import 'package:babx/components/my_BigButtonColored.dart';
import 'package:babx/components/my_buttonColored.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
        .where('winner', whereIn: [1, 0])
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
            const SnackBar(content: Text('Vous êtes déjà dans une équipe')));
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

  Future<void> _changeTeam(DocumentReference matchDoc, String newTeam) async {
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

      await matchDoc.update(updates);
      await _joinTeam(matchDoc, newTeam);
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
      } else {
        showErrorMessage('Il faut au moins un joueur dans chaque équipe pour commencer la partie.');
      }
    }
  }

  void _joinAsSpectator(DocumentReference matchDoc) async {
    await _removePlayerFromTeam(matchDoc);
    setState(() {
      waitingPlayers.add(user!.email!);
    });
  }

  Future<void> _updateScore(DocumentReference matchDoc, String team, int score) async {
    await matchDoc.update({
      '${team}_score': FieldValue.increment(score),
    });

    final matchSnapshot = await matchDoc.get();
    final matchData = matchSnapshot.data() as Map<String, dynamic>?;
    if (matchData != null && matchData['${team}_score'] >= 10) {
      int winnerTeam = team == 'blue' ? 2 : 3; // 2 pour l'équipe bleue, 3 pour l'équipe rouge

      await matchDoc.update({
        'winner': winnerTeam,
      });

      List<String?> winningTeamPlayers = [];
      List<String?> losingTeamPlayers = [];

      if (winnerTeam == 2) {
        winningTeamPlayers = [
          matchData['blue_player_1'],
          matchData['blue_player_2'],
        ];
        losingTeamPlayers = [
          matchData['red_player_1'],
          matchData['red_player_2'],
        ];
      } else {
        winningTeamPlayers = [
          matchData['red_player_1'],
          matchData['red_player_2'],
        ];
        losingTeamPlayers = [
          matchData['blue_player_1'],
          matchData['blue_player_2'],
        ];
      }

      await _updateUserProfiles(winningTeamPlayers, true, matchData['babyfoot']);
      await _updateUserProfiles(losingTeamPlayers, false, matchData['babyfoot']);

      await _createNewMatch();
    }
  }

  Future<void> _updateUserProfiles(List<String?> playerEmails, bool won, String babyfootName) async {
    for (String? email in playerEmails) {
      if (email != null) {
        final userQuery = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
        if (userQuery.docs.isNotEmpty) {
          final userDoc = userQuery.docs.first.reference;
          await userDoc.update({
            'total_games': FieldValue.increment(1),
            'wins': won ? FieldValue.increment(1) : FieldValue.increment(0),
            'loss': won ? FieldValue.increment(0) : FieldValue.increment(1),
            'nb_goals': FieldValue.increment(10),
            'nb_conceded': FieldValue.increment(0),
          });
        }
      }
    }
  }

  Future<void> _createNewMatch() async {
    final newMatchDoc = await _firestore.collection('matches').add({
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BabyfootLobbyPage(widget.babyfootName),
      ),
    );
  }

  void showErrorMessage(String message) {
    print("No user found");
    QuickAlert.show(
      context: context,
      customAsset: 'assets/images/sad.gif',
      type: QuickAlertType.error,
      title: 'Oups...',
      text: message,
    );
  }

  @override
  void dispose() {
    matchDocFuture.then((matchDoc) => _removePlayerFromTeam(matchDoc));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: FutureBuilder<DocumentReference>(
        future: matchDocFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final matchDoc = snapshot.data!;
          return StreamBuilder<DocumentSnapshot>(
            stream: matchDoc.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data!.data() as Map<String, dynamic>;

              if (data['winner'] == 0) {
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
                      const SizedBox(height: 50,),
                      const Text('Équipe Bleue:', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 25)),
                      const SizedBox(height: 10,),
                      Text('Joueur 1: ${data['blue_player_1'] ?? 'Vide'}', style: const TextStyle(color: Colors.white)),
                      Text('Joueur 2: ${data['blue_player_2'] ?? 'Vide'}', style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 15,),
                      if (!isBluePlayer && !isRedPlayer)
                        MyButtonColored(
                          onTap: () => _joinTeam(matchDoc, 'blue'),
                          text: "Rejoindre l'équipe bleue",
                          color: Colors.blue,
                        ),
                      const SizedBox(height: 50,),
                      const Text('Équipe Rouge:', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 25)),
                      const SizedBox(height: 10,),
                      Text('Joueur 1: ${data['red_player_1'] ?? 'Vide'}', style: const TextStyle(color: Colors.white)),
                      Text('Joueur 2: ${data['red_player_2'] ?? 'Vide'}', style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 15,),
                      if (!isRedPlayer && !isBluePlayer)
                        MyButtonColored(
                          onTap: () => _joinTeam(matchDoc, 'red'),
                          text: "Rejoindre l'équipe rouge",
                          color: Colors.red,
                        ),
                      const SizedBox(height: 50,),

                      if (isRedPlayer)
                        MyButtonColored(
                          onTap: () => _changeTeam(matchDoc, 'blue'),
                          text: "Changer pour l'équipe bleue",
                          color: Colors.blue,
                        ),
                      if (isBluePlayer)
                        MyButtonColored(
                          onTap: () => _changeTeam(matchDoc, 'red'),
                          text: "Changer pour l'équipe rouge",
                          color: Colors.red,
                        ),
                      const SizedBox(height: 25,),
                      if (!isSpectator)
                        ElevatedButton(
                          onPressed: () => _joinAsSpectator(matchDoc),
                          child: const Text('Rejoindre les Spectateurs'),
                        ),
                      const SizedBox(height: 15,),
                      const Text('En attente:', style: TextStyle(color: Colors.white)),
                      Column(
                        children: waitingPlayers
                            .where((player) => !allPlayers.contains(player))
                            .map((player) => Text(player, style: const TextStyle(color: Colors.white)))
                            .toList(),
                      ),
                      const SizedBox(height: 110,),
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
              } else {
                return Scaffold(
                  backgroundColor: Colors.grey[900],
                  body: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${data['blue_score']}',
                                style: const TextStyle(
                                  fontSize: 100,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${data['blue_player_1'] ?? 'Vide'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${data['blue_player_2'] ?? 'Vide'}',
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
                                '${data['red_score']}',
                                style: const TextStyle(
                                  fontSize: 100,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${data['red_player_1'] ?? 'Vide'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${data['red_player_2'] ?? 'Vide'}',
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
                  ),
                  floatingActionButton: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () => _updateScore(matchDoc, 'blue', 1),
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        onPressed: () => _updateScore(matchDoc, 'red', 1),
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
