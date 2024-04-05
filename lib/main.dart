import 'package:badger_market/page/home.dart';
import 'package:badger_market/page/login_page.dart';
import 'package:badger_market/page/register_page.dart';
// import 'package:badger_market/page/loginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: RegisterPage(),
    );
  }
}
