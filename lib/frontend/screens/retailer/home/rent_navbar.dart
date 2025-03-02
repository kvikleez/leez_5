import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:leez/frontend/screens/retailer/chat/message_screen.dart';
import 'package:leez/frontend/screens/retailer/rental/selling.dart';
import 'package:leez/frontend/screens/user/profile/profile.dart';
import 'homescreeno.dart';

class MyRetailerPage extends StatefulWidget {
  const MyRetailerPage({super.key});

  @override
  _MyRetailerPageState createState() => _MyRetailerPageState();
}

class _MyRetailerPageState extends State<MyRetailerPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SellingScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  void _onBottomNavigationBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true, // Makes the body extend behind the navbar
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
              backgroundColor:
                  Colors.transparent, // To preserve the glass effect
              elevation: 0, // Removes any default shadow
              selectedItemColor: Colors.black,
              unselectedItemColor: const Color.fromARGB(255, 69, 65, 65),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  activeIcon: Icon(Icons.inventory_2),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  activeIcon: Icon(Icons.chat_bubble),
                  label: 'Chats',
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

