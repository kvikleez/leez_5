// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:leez/screens/profile/settings.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'LEEZ Connect',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Colors.black),
//         ),
//       ),
//       home: const ProfileScreen(),
//     );
//   }
// }

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late final List<ProfileSettingItem> _settingsItems;

//   @override
//   void initState() {
//     super.initState();
//     _settingsItems = [
//       ProfileSettingItem(
//         icon: Iconsax.user,
//         title: "Personal Information",
//         onTap: () => _navigateToDetail("Personal Information"),
//       ),
//       ProfileSettingItem(
//         icon: Iconsax.lock,
//         title: "Login & Security",
//         onTap: () => _navigateToDetail("Login & Security"),
//       ),
//       ProfileSettingItem(
//         icon: Iconsax.card,
//         title: "Payments & Payouts",
//         onTap: () => _navigateToDetail("Payments & Payouts"),
//       ),
//       ProfileSettingItem(
//         icon: Iconsax.eye,
//         title: "Accessibility",
//         onTap: () => _navigateToDetail("Accessibility"),
//       ),
//       ProfileSettingItem(
//         icon: Iconsax.translate,
//         title: "Translation",
//         onTap: () => _navigateToDetail("Translation"),
//       ),
//       ProfileSettingItem(
//         icon: Iconsax.notification,
//         title: "Notifications",
//         onTap: () => _navigateToDetail("Notifications"),
//       ),
//       ProfileSettingItem(
//         icon: Iconsax.shield_tick,
//         title: "Privacy & Sharing",
//         onTap: () => _navigateToDetail("Privacy & Sharing"),
//       ),
//       ProfileSettingItem(
//         icon: Iconsax.briefcase,
//         title: "Travel for Work",
//         onTap: () => _navigateToDetail("Travel for Work"),
//       ),
//     ];
//   }

//   void _navigateToDetail(String title) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Navigating to $title")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () => _showMoreOptions(),
//           ),
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) => SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(minHeight: constraints.maxHeight),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildProfileHeader(),
//                 _buildPromotionalCard(),
//                 _buildSettingsSection(),
//                 // Add empty container for future content
//                 Container(height: MediaQuery.of(context).size.height * 0.2),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 40,
//             backgroundImage: AssetImage("assets/boy.png"),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Mr Leez",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 InkWell(
//                   onTap: () => _navigateToDetail("Profile"),
//                   child: const Text(
//                     "Show Profile",
//                     style: TextStyle(
//                       color: Colors.blue,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.edit, color: Colors.black),
//             onPressed: () => _navigateToDetail("Edit Profile"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPromotionalCard() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   "Host Your Space",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Earn extra income by hosting your property.",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               image: const DecorationImage(
//                 image: AssetImage("assets/boy.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Text(
//             "Settings",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Column(
//           children: List.generate(
//             _settingsItems.length,
//             (index) => Column(
//               children: [
//                 ListTile(
//                   leading: Icon(_settingsItems[index].icon, color: Colors.black),
//                   title: Text(_settingsItems[index].title),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: _settingsItems[index].onTap,
//                 ),
//                 if (index < _settingsItems.length - 1)
//                   const Divider(height: 1, indent: 16, endIndent: 16),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

// void _showMoreOptions() {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) => Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ListTile(
//           leading: const Icon(Icons.settings),
//           title: const Text("Advanced Settings"),
//           onTap: () {
//             Navigator.pop(context); // Close bottom sheet
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const SettingsScreen(),
//               ),
//             );
//           },
//         ),
//           ListTile(
//             leading: const Icon(Icons.help_outline),
//             title: const Text("Help & Support"),
//             onTap: () => Navigator.pop(context),
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text("Log Out"),
//             onTap: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProfileSettingItem {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   ProfileSettingItem({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });
// }