import 'package:flutter/material.dart';
import 'package:leez/frontend/screens/user/chat/messages_screen.dart';
import 'package:leez/frontend/screens/user/home/homescreen.dart';
import 'package:leez/frontend/screens/user/home/wishlist_screen.dart';
import 'package:leez/frontend/screens/user/profile/profile.dart';
import 'dart:ui';


class NavBar extends StatefulWidget {
  const NavBar({super.key});
  
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = const [
    HomeScreen(),
    WishlistsScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  void _onBottomNavigationBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Main scaffold including the Bottom Navigation Bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      extendBody: true, // Important to make the body extend behind the navbar
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
              border: const Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 0.2,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onBottomNavigationBarTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent, // Important for the glass effect
              elevation: 0, // Remove shadow
              selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              unselectedItemColor: const Color.fromARGB(255, 84, 82, 82),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline),
                  activeIcon: Icon(Icons.favorite),
                  label: 'Wishlists',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_outlined),
                  activeIcon: Icon(Icons.chat),
                  label: 'Inbox',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}