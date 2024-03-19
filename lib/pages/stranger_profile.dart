import 'package:babx/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowStrangerProfile extends StatelessWidget {
  final String userEmail;

  const ShowStrangerProfile({Key? key, required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white60,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            String winRate = '0';
            if (userData['total_games'] != 0) {
              double rate = (userData['wins'] / userData['total_games']) * 100;
              winRate = rate.toStringAsFixed(2);
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 210,
                        ),
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: [
                            Column(
                              children: [
                                buildColoredBox(
                                  "Victoires",
                                  "${userData['wins']}",
                                  Colors.blueAccent,
                                  150,
                                  170,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                buildColoredBox(
                                  "Parties jouées",
                                  "${userData['total_games']}",
                                  Colors.redAccent,
                                  150,
                                  100,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                buildColoredBox(
                                  "Défaites",
                                  "${userData['loss']}",
                                  Colors.orange,
                                  150,
                                  100,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                buildColoredBox(
                                  "Partenaire Favori",
                                  "${userData['fav_mate']}",
                                  Colors.greenAccent,
                                  170,
                                  130,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                buildColoredBox(
                                  "Adversaires affrontés",
                                  "${userData['total_opponents']}",
                                  Colors.red,
                                  170,
                                  100,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                buildColoredBox(
                                  "Babyfoot Favori",
                                  "${userData['fav_babyfoot']}",
                                  Colors.green,
                                  170,
                                  140,
                                ),
                              ],
                            ),
                            buildColoredBox(
                              "Winrate",
                              "$winRate %",
                              Colors.purple,
                              330,
                              100,
                            ),
                            Column(
                              children: [
                                buildColoredBox(
                                  "Style de jeu",
                                  "${userData['gamestyle']}",
                                  Colors.deepOrangeAccent,
                                  150,
                                  170,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                buildColoredBox(
                                  "Buts marqués",
                                  "${userData['nb_goals']}",
                                  Colors.lightBlueAccent,
                                  170,
                                  80,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                buildColoredBox(
                                  "Buts encaissés",
                                  "${userData['nb_conceded']}",
                                  Colors.red,
                                  170,
                                  80,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                ),
                const Positioned(
                  top: 52,
                  left: 22,
                  child: CircleAvatar(
                    radius: 72,
                    backgroundColor: Colors.black,
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 30,
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(
                      userData['img_url'],
                    ),
                    foregroundColor: Colors.black,
                    foregroundImage: NetworkImage(
                      userData['img_url'],
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 190,
                  child: Column(
                    children: [
                      Text(
                        "${userData['firstname']}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 110,
                  left: 190,
                  child: Column(
                    children: [
                      Text(
                        '${userData['lastname']}'.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}