import 'package:flutter/material.dart';

import '../page/home_page.dart';

class CartAppBarAction extends StatefulWidget {
  const CartAppBarAction({Key? key}) : super(key: key);

  @override
  State<CartAppBarAction> createState() => _CartAppBarActionState();
}

class _CartAppBarActionState extends State<CartAppBarAction> {
  // TODO: Setup cart to listen for changes based on your own state management. Could use riverpod, provider, bloc, etc..
  @override
  void initState() {
    cart.addListener(blankSetState);
    super.initState();
  }

  @override
  void dispose() {
    cart.removeListener(blankSetState);
    super.dispose();
  }

  void blankSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.shopping_cart,
          ),
          if (cart.itemsInCart.isNotEmpty)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        cart.itemsInCart.length.toString(),
                        style: const TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ), onPressed: () { print(1); },
      
    );
  }
}