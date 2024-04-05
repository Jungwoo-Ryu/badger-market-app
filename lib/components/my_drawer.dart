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
      // backgroundColor: Theme.of(context).colorScheme,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            //Logo
          DrawerHeader(
            child: Center(
              child: ImageIcon(
              const AssetImage("assets/images/Bucky.png"),
              size: 100,
              color:Colors.red.shade400,
              ),
              ),
          ),

          // home list tile
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
          // message list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("M E S S A G E"),
              leading: const Icon(Icons.message),
              onTap: () {},
            ),
          ),


          // settings list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("S E T T I N G S"),
              leading: const Icon(Icons.settings),
              onTap: () {
                // pop the drawer
                Navigator.pop(context);
                
                // navigate to settings page
                Navigator.push(context, MaterialPageRoute(builder: 
                (context) => const SettingsPage(),));
              },
            ),
          ),
          ],),

          // logout list tile
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