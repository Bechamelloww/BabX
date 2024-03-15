import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'hub.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "BabX",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Center(
                      child: Text(
                    "Connecté en tant que ${userData['username']}",
                        style: const TextStyle(color: Colors.white60),
                  )),
                  const SizedBox(
                    height: 60,
                  ),
                  const Center(
                    child: Text(
                      "Le Top 5",
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - 300,
                      ),
                      child: DataTable(
                        dividerThickness: 1,
                        columns: const [
                          DataColumn(
                              label: Text(
                            'Nom',
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          )),
                          DataColumn(
                              label: Text(
                            'Victoires',
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          )),
                        ],
                        rows: [
                          DataRow(cells: [
                            const DataCell(Text(
                              'Gabriel MARIE',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
                            DataCell(Text(
                              '81',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15),
                            )),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text(
                              'John DOE',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
                            DataCell(Text(
                              '10',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15),
                            )),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text(
                              'Marco MARCONI',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
                            DataCell(Text(
                              '5',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15),
                            )),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text(
                              'Lionel MESSI',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
                            DataCell(Text(
                              '3',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15),
                            )),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text(
                              'Cristiano RONALDO',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
                            DataCell(Text(
                              '0',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15),
                            )),
                          ]),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child:Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
