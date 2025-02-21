import 'package:badger_market/page/messnager_page.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../page/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    'assets/images/Bucky.png',
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),
              // Message list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("M E S S A G E"),
                  leading: const Icon(Icons.message),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MessengerPage()),
                    );
                  },
                ),
              ),
              // Settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                    // navigate to settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Logout list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}