// import 'package:flutter/material.dart';
// import 'package:flutter_settings_ui/flutter_settings_ui.dart';
// import 'package:leez/screens/profile/profile.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: SettingsList(
//         sections: [
//           SettingsSection(
//             title: const Text('Account'),
//             tiles: <SettingsTile>[
//               SettingsTile(
//                 leading: const Icon(Icons.person),
//                 title: const Text('Profile'),
//                 onPressed: (context) {
//                               Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const ProfileScreen(),
//               ),
//             );
//                   // TODO: Navigate to Profile Page
//                 },
//               ),
//               SettingsTile(
//                 leading: const Icon(Icons.lock),
//                 title: const Text('Privacy'),
//                 onPressed: (context) {
//                   // TODO: Navigate to Privacy Page
//                 },
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: const Text('General'),
//             tiles: <SettingsTile>[
//               SettingsTile(
//                 leading: const Icon(Icons.notifications),
//                 title: const Text('Notifications'),
//                 onPressed: (context) {
//                   // TODO: Handle Notifications Settings
//                 },
//               ),
//               SettingsTile(
//                 leading: const Icon(Icons.language),
//                 title: const Text('Language'),
//                 onPressed: (context) {
//                   // TODO: Change Language
//                 },
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: const Text('Security'),
//             tiles: <SettingsTile>[
//               SettingsTile(
//                 leading: const Icon(Icons.security),
//                 title: const Text('Change Password'),
//                 onPressed: (context) {
//                   // TODO: Navigate to Change Password Page
//                 },
//               ),
//               SettingsTile(
//                 leading: const Icon(Icons.fingerprint),
//                 title: const Text('Fingerprint Authentication'),
//                 onPressed: (context) {
//                   // TODO: Navigate to Fingerprint Authentication Page
//                 },
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: const Text('About'),
//             tiles: <SettingsTile>[
//               SettingsTile(
//                 leading: const Icon(Icons.info),
//                 title: const Text('App Version'),
//                 onPressed: (context) {
//                   // TODO: Handle App Version tap
//                 },
//               ),
//               SettingsTile(
//                 leading: const Icon(Icons.verified_user),
//                 title: const Text('License Agreement'),
//                 onPressed: (context) {
//                   // TODO: Navigate to License Agreement Page
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
