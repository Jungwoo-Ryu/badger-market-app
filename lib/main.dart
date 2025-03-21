// import 'package:badger_market/page/home.dart';
import 'package:badger_market/core/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:badger_market/page/loginPage.dart';
import 'package:flutter/material.dart';

import 'services/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badger Market',
      theme: AppTheme.darkThemeMode,
      home: const AuthGate(),

    );
  }
}
