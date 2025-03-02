import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Account'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onPressed: (BuildContext context) {
                  // Navigate to Profile Page
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.lock),
                title: const Text('Privacy'),
                onPressed: (BuildContext context) {
                  // Navigate to Privacy Page
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('General'),
            tiles: <SettingsTile>[
              // Use SettingsTile with a Switch widget directly
              SettingsTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
              ),
              SettingsTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                // Remove subtitle
                onPressed: (BuildContext context) {
                  // Change language
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Support'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Feedback'),
                onPressed: (BuildContext context) {
                  // Navigate to Help Page
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Security'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.security),
                title: const Text('Change Password'),
                onPressed: (BuildContext context) {
                  // Navigate to Change Password Page
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text('Fingerprint Authentication'),
                onPressed: (BuildContext context) {
                  // Navigate to Fingerprint Authentication Page
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('About'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.info),
                title: const Text('App Version'),
                // Remove subtitle
                onPressed: (BuildContext context) {
                  // Handle App Version tap
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.verified_user),
                title: const Text('License Agreement'),
                onPressed: (BuildContext context) {
                  // Navigate to License Agreement Page
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
