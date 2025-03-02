import 'package:flutter/material.dart';
import 'package:leez/screens/ret/selling.dart';
import 'package:leez/screens/user/messages/messages_screen.dart';
import 'package:leez/screens/user/profile/profile.dart';
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
    // SearchScreen(),
    ChatScreen(),
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

      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavigationBarTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_outlined), // Dashboard Icon
      activeIcon: Icon(Icons.bar_chart), 
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.inventory_2_outlined), // Products Icon
      activeIcon: Icon(Icons.inventory_2), 
      label: 'Products',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline), // Chats Icon
      activeIcon: Icon(Icons.chat_bubble), 
      label: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline), // Profile Icon
      activeIcon: Icon(Icons.person), 
      label: 'Profile',
    ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search Screen'),
    );
  }
}

