

import 'package:dailytask_app/AuthController.dart';
import 'package:dailytask_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return GetMaterialApp(
      home: LoginPage(),
    );
  }
}
