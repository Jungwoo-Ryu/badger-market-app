import 'package:flutter/material.dart';
import '../cart/cart.dart';
import 'home_screen.dart';

Cart cart = Cart();

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Builder(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}




