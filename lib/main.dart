import 'package:badger_market/firebase_options.dart';
import 'package:badger_market/page/home.dart';
import 'package:badger_market/page/login_page.dart';
import 'package:badger_market/page/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:badger_market/page/loginPage.dart';
import 'package:flutter/material.dart';

import 'services/auth/auth_gate.dart';
import 'services/auth/login_or_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badger Market',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const AuthGate(),

    );
  }
}
