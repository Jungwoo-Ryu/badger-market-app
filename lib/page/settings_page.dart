import 'package:badger_market/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  
  get value => null;

  void logout() {
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings")
        , backgroundColor: const Color.fromRGBO(161, 32, 43, 1),  
        ),
      body:  SettingsList(
        sections: [
          SettingsSection(
            title: Text('Section'),
            tiles: [
              SettingsTile(
                title: Text('Sign Out'),
                leading: Icon(Icons.logout),
                onPressed: (BuildContext context) {
                  logout();
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}