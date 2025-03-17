import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  
  get value => null;

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
              SettingsTile.navigation(
                title: Text('Language'),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
        ],
      )
    );
  }
}