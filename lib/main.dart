import 'dart:html';

import 'package:dailytask_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await initializeFirebase();
  runApp(const MainApp());

}

initializeFirebase() async {
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
 );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
