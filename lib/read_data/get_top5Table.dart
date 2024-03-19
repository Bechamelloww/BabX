import 'package:babx/pages/Home.dart';
import 'package:babx/pages/profile.dart';
import 'package:babx/pages/stranger_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetTop5Table extends StatelessWidget {
  const GetTop5Table();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('wins', descending: true)
          .limit(5) // Limit to only 5 documents
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final usersData = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 300,
              ),
              child: DataTable(
                dividerThickness: 1,
                dataRowMaxHeight: 70,
                columns: const [
                  DataColumn(
                    numeric: false,
                    label: Text(""),
                  ),
                  DataColumn(
                      label: Text(
                    'Utilisateur',
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  )),
                  DataColumn(
                      label: Text(
                    'Victoires',
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  )),
                ],
                rows: usersData.map((userData) {
                  final data = userData.data() as Map<String, dynamic>;
                  return DataRow(cells: [
                    DataCell(
                      IconButton(
                        icon: CircleAvatar(
                          radius: 23,
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(userData['img_url']),
                        ),
                        onPressed: () {
                          if (userData['uid'] !=
                              FirebaseAuth.instance.currentUser?.uid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowStrangerProfile(
                                    userEmail: userData['email']),
                              ),
                            );
                          } else {

                          }
                        },
                      ),
                    ),
                    DataCell(Text(
                      data['username'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    )),
                    DataCell(Text(
                      data['wins'].toString(),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 15),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
