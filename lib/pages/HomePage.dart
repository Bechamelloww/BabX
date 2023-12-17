import 'package:flutter/material.dart';

import 'EventPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/aroufe0.png",
          ),
          const Text("Arouf Gangsta",
            style: TextStyle(
                fontSize: 40,
                fontFamily: 'Poppins'
            ),
          ),
          const Text("Old...",
            style: TextStyle(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    );
  }
}