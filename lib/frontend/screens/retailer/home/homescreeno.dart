import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a CustomScrollView to support SliverAppBar collapse on scroll
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with flexible space containing a search bar
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 200,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            elevation: 2,
            centerTitle: true,
            title: Image.asset(
              'assets/logo/quickleez_1.png',
              height: 50,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  // TODO: Implement notifications functionality
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
                child: _buildSearchBar(),
              ),
            ),
          ),
          // SliverList for the body sections
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _sectionTitle('Products Overview'),
                _buildOverviewCards(),
                _sectionTitle('Boosted Products Performance'),
                _buildPerformanceCards(),
                _sectionTitle('Highly In-Demand Products'),
                _buildProductList(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A modern, rounded search bar with a subtle shadow.
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  /// Section title styling.
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Overview cards section: two rows of stat cards.
  Widget _buildOverviewCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatCard('Total Products', '284', '+12%'),
              _buildStatCard('Active Products', '156', '+8%'),
            ],
          ),
          Row(
            children: [
              _buildStatCard('Available for Rent', '98', '-3%'),
              _buildStatCard('User Requests', '426', '+15%'),
            ],
          ),
        ],
      ),
    );
  }

  /// Individual stat card for overview section.
  Widget _buildStatCard(String title, String value, String percentage) {
    bool isNegative = percentage.contains('-');
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              percentage,
              style: TextStyle(
                color: isNegative ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Performance cards section.
  Widget _buildPerformanceCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildPerformanceCard('Total Reach', '15.2K', Icons.visibility),
          _buildPerformanceCard('Total Clicks', '3.8K', Icons.touch_app),
        ],
      ),
    );
  }

  /// Individual performance card.
  Widget _buildPerformanceCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(icon, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

  /// Product list section.
  Widget _buildProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildProductCard('Red Car Max 2024', 'assets/car4.jpg', '2.4k', '126'),
          _buildProductCard('White Car Pro', 'assets/car1.png', '1.8k', '94'),
        ],
      ),
    );
  }

  /// Individual product card.
  Widget _buildProductCard(String title, String imagePath, String views, String requests) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Views: $views', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Requests: $requests', style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
