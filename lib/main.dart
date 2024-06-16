import 'package:flutter/material.dart';
import 'package:babx/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: const AuthPage(),
      theme: ThemeData(
        dividerColor: Colors.blue,
        primaryColor: Colors.redAccent,
        secondaryHeaderColor: Colors.redAccent,
        hintColor: Colors.redAccent,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.redAccent,
          selectionColor: Colors.redAccent.withOpacity(0.4),
          selectionHandleColor: Colors.redAccent,

        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle:
          TextStyle(color: Colors.redAccent, fontSize: 15),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
