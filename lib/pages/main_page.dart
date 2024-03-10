import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'hub.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900], // Changer ici pour la couleur de fond souhaitée
      child: Center(
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
                color: Colors.white
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Center(
              child: Text("Connecté en tant que ${user!.email!}",
                style: const TextStyle(
                    color: Colors.white60
                ),),

            ),
            const SizedBox(height: 60,),
            const Center(
              child: Text("Le Top 5",
                style: TextStyle(
                    color: Colors.white60,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),),

            ),
            const SizedBox(height: 25,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 300,
                ),
                child: DataTable(
                  dividerThickness: 1,
                  columns: const [
                    DataColumn(label: Text('Nom', style: TextStyle(color: Colors.white, fontSize: 19),)),
                    DataColumn(label: Text('Victoires', style: TextStyle(color: Colors.white, fontSize: 19),)),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('Gabriel MARIE', style: TextStyle(color: Colors.white, fontSize: 15),)),
                      DataCell(Text('81', style: TextStyle(color: Colors.white, fontSize: 15),)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('John DOE', style: TextStyle(color: Colors.white, fontSize: 15),)),
                      DataCell(Text('10', style: TextStyle(color: Colors.white, fontSize: 15),)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Marco MARCONI', style: TextStyle(color: Colors.white, fontSize: 15),)),
                      DataCell(Text('5', style: TextStyle(color: Colors.white, fontSize: 15),)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Lionel MESSI', style: TextStyle(color: Colors.white, fontSize: 15),)),
                      DataCell(Text('3', style: TextStyle(color: Colors.white, fontSize: 15),)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Cristiano RONALDO', style: TextStyle(color: Colors.white, fontSize: 15),)),
                      DataCell(Text('0', style: TextStyle(color: Colors.white, fontSize: 15),)),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
