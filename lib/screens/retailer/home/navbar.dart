// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:leez/screens/home/homescreen.dart';
// import 'package:leez/screens/home/wishlist_screen.dart';
// import 'package:leez/screens/messages/messages_screen.dart';
// import 'package:leez/screens/messages/trips.dart';
// import 'package:leez/screens/profile/profile.dart';
// // ... other imports ...

// class NavBar extends StatefulWidget {
//   const NavBar({Key? key}) : super(key: key);

//   @override
//   _PersistentBottomNavBarState createState() => _PersistentBottomNavBarState();
// }

// class _PersistentBottomNavBarState extends State<NavBar> with TickerProviderStateMixin {
//   int _currentIndex = 0;
//   static const Color _activeColor = Colors.black;
//   static const Color _inactiveColor = Colors.grey;
//   late AnimationController _controller;

//   final List<Widget> _screens = const [
//     HomeScreen(),
//     WishlistsScreen(),
//     TripsScreen(),
//     MessagesScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Animated content switching
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             transitionBuilder: (Widget child, Animation<double> animation) {
//               return SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(0.2, 0),
//                   end: Offset.zero,
//                 ).animate(CurvedAnimation(
//                   parent: animation,
//                   curve: Curves.easeOutCubic,
//                 )),
//                 child: FadeTransition(
//                   opacity: animation,
//                   child: child,
//                 ),
//               );
//             },
//             child: _screens[_currentIndex],
//           ),

//           // Floating Navbar
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: screenHeight * 0.01,
//             child: _buildFloatingNavBar(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFloatingNavBar(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(32),
//         child: BackdropFilter(
//           filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
//           child: Container(
//             height: screenWidth * 0.14,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.9),
//               borderRadius: BorderRadius.circular(32),
//               border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.04),
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: _buildNavItems(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildNavItems() {
//     final items = [
//       NavItemData(Iconsax.home, Iconsax.home_15, 'Home'),
//       NavItemData(Iconsax.heart, Iconsax.heart5, 'Wishlists'),
//       NavItemData(Iconsax.car, Iconsax.car5, 'Trips'),
//       NavItemData(Iconsax.message, Iconsax.message5, 'Inbox'),
//       NavItemData(Iconsax.user, Iconsax.user_tick, 'Profile'),
//     ];

//     return List.generate(
//       items.length,
//       (index) => _buildNavItem(index, items[index]),
//     );
//   }

//   Widget _buildNavItem(int index, NavItemData item) {
//     final bool isSelected = _currentIndex == index;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _currentIndex = index;
//           _controller.reset();
//           _controller.forward();
//         });
//       },
//       child: SizedBox(
//         width: 70,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               transitionBuilder: (child, animation) => ScaleTransition(
//                 scale: animation,
//                 child: child,
//               ),
//               child: isSelected
//                   ? _AnimatedIconWrapper(
//                       key: ValueKey('${item.label}-filled'),
//                       icon: item.filledIcon,
//                       color: _activeColor,
//                     )
//                   : _AnimatedIconWrapper(
//                       key: ValueKey('${item.label}-outline'),
//                       icon: item.outlineIcon,
//                       color: _inactiveColor,
//                     ),
//             ),
//             const SizedBox(height: 4),
//             AnimatedScale(
//               scale: isSelected ? 1.1 : 1.0,
//               duration: const Duration(milliseconds: 200),
//               child: Text(
//                 item.label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: isSelected ? _activeColor : _inactiveColor,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AnimatedIconWrapper extends StatelessWidget {
//   final IconData icon;
//   final Color color;

//   const _AnimatedIconWrapper({
//     required Key key,
//     required this.icon,
//     required this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       child: Icon(
//         icon,
//         color: color,
//         size: 24,
//       ),
//     );
//   }
// }

// class NavItemData {
//   final IconData outlineIcon;
//   final IconData filledIcon;
//   final String label;

//   NavItemData(this.outlineIcon, this.filledIcon, this.label);
// }
