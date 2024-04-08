import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import '../DTO/products.dart';
import '../cart/cart.dart';
import '../components/UserTile.dart';
import '../components/my_drawer.dart';
import '../components/search_bar.dart';
import 'chat_page.dart';
import 'home_screen.dart';

Cart cart = Cart();

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Builder(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}




