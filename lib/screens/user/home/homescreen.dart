import 'package:flutter/material.dart';
import 'package:leez/screens/user/product/product.dart';
import 'package:leez/models/property.dart';
import 'package:provider/provider.dart';
import 'package:leez/providers/property_provider.dart';

// ------------------- THEME SETUP (Unchanged) -------------------
ThemeData _buildAppTheme() {
  return ThemeData(
    primaryColor: const Color.fromARGB(255, 0, 0, 0),
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 0, 0, 0),
      secondary: Color(0xFF222222),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF222222)),
    ),
    fontFamily: 'Cereal',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF222222)),
      titleMedium: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF222222)),
    ),
  );
}

// Category item for the TabBar (icon + label)
class CategoryItem {
  final IconData icon;
  final String label;
  CategoryItem({required this.icon, required this.label});
}

// ------------------- PROPERTY CARD -------------------
class PropertyCard extends StatelessWidget {
  final Property property;
  final bool showTotalPrice;
  final VoidCallback onToggleFavorite;

  const PropertyCard({
    super.key,
    required this.property,
    required this.showTotalPrice,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListingDetailPage(property: property),
          ),
        );
      },
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    property.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey);
                    },
                  ),
                  if (property.isGuestFavorite)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Guest favourite',
                              style: TextStyle(
                                color: Color(0xFF222222),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.favorite,
                              color: Color(0xFFFF5A5F),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      icon: Icon(
                        property.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: property.isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: onToggleFavorite,
                    ),
                  ),
                  if (property.hasMap)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.map, size: 16, color: Color(0xFF222222)),
                            SizedBox(width: 4),
                            Text(
                              'Map',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF222222),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.location,
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      property.distanceDescription,
                      style: const TextStyle(
                        color: Color(0xFF717171),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      property.availabilityDescription,
                      style: const TextStyle(
                        color: Color(0xFF717171),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Color(0xFF222222), fontSize: 14),
                        children: [
                          TextSpan(
                            text: showTotalPrice
                                ? '₹${property.totalPrice}'
                                : '₹${property.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(
                            text: ' night',
                            style: TextStyle(
                              color: Color(0xFF717171),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Color(0xFFFF5A5F),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property.rating.toString(),
                        style: const TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------- SEARCH BAR (Unchanged) -------------------
class _SearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.search, color: Colors.grey.shade800, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Start your search',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- SERVICE (Dummy) -------------------
class PropertiesService {
  Future<List<Property>> getProperties() async {
    // TODO: Implement actual data fetching logic
    return [];
  }
}

// ------------------- HOME SCREEN WITH TABBAR -------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Track search query and total price toggle
  String _searchQuery = '';
  bool _showTotalPrice = false;

  // Define categories as Tabs
  final List<CategoryItem> _tabCategories = [
    CategoryItem(icon: Icons.directions_car, label: 'Cars'),
    CategoryItem(icon: Icons.motorcycle, label: 'Bikes'),
    CategoryItem(icon: Icons.house, label: 'Farms'),
    CategoryItem(icon: Icons.house_siding, label: 'Icons'),
    CategoryItem(icon: Icons.water, label: 'Amazing pools'),
    CategoryItem(icon: Icons.beach_access, label: 'Beachfront'),
    CategoryItem(icon: Icons.house_rounded, label: 'Lake'),
    CategoryItem(icon: Icons.laptop, label: 'Laptops'),
    CategoryItem(icon: Icons.camera_alt, label: 'Cameras'),
    CategoryItem(icon: Icons.smartphone, label: 'Mobiles'),
    CategoryItem(icon: Icons.category, label: 'Other'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCategories.length, vsync: this);
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
  }

  // Filter properties by category + search query
  List<Property> _getFilteredProperties(String categoryLabel, List<Property> allProps) {
    return allProps.where((property) {
      final matchesCategory = property.category == categoryLabel;
      final matchesSearch = _searchQuery.isEmpty ||
          property.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          property.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }


  Widget _buildSearchBar() {
    // A pill-shaped search container like Airbnb
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Start your search',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPriceToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Display total price',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 2),
              Text(
                'Includes all fees, before taxes',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Switch(
            value: _showTotalPrice,
            onChanged: (value) => setState(() => _showTotalPrice = value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access our PropertyProvider
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final allProperties = propertyProvider.allProperties;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              floating: false,
              expandedHeight: 120,
              backgroundColor: const Color.fromARGB(0, 255, 255, 255).withOpacity(0.7),
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 65),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Start your search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.black,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                    tabs: _tabCategories.map((cat) {
                      return Tab(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(cat.icon, size: 22),
                            const SizedBox(width: 8),
                            Text(cat.label, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Display total price',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Includes all fees, before taxes',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _showTotalPrice,
                      onChanged: (value) => setState(() => _showTotalPrice = value),
                      activeColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabCategories.map((category) {
            final filteredProps = _getFilteredProperties(category.label, allProperties);
            return ListView.builder(
              itemCount: filteredProps.length,
              itemBuilder: (context, index) {
                final prop = filteredProps[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PropertyCard(
                    property: prop,
                    showTotalPrice: _showTotalPrice,
                    onToggleFavorite: () {
                      // Toggle the favorite in our provider
                      propertyProvider.toggleFavorite(prop);
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}