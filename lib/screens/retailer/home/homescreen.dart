// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:leez/screens/product/product.dart';

// // Theme remains the same as before
// ThemeData _buildAppTheme() {
//   return ThemeData(
//     primaryColor: const Color(0xFFFF5A5F),
//     colorScheme: const ColorScheme.light(
//       primary: Color(0xFFFF5A5F),
//       secondary: Color(0xFF222222),
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       iconTheme: IconThemeData(color: Color(0xFF222222)),
//     ),
//     fontFamily: 'Cereal',
//   );
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Property> _allProperties = [];
//   String _searchQuery = "";
//   int _selectedCategoryIndex = 0;
//   bool _showTotalPrice = false;

//   // Updated categories with icons
// final List<CategoryItem> _categories = [
//   CategoryItem(icon: Icons.directions_car, label: 'Cars'),
//   CategoryItem(icon: Icons.motorcycle, label: 'Bikes'),
//   CategoryItem(icon: Icons.laptop_mac, label: 'Laptops'),
//   CategoryItem(icon: Icons.photo_camera, label: 'Cameras'),
//   CategoryItem(icon: Icons.house, label: 'Houses'),
// ];


//   @override
//   void initState() {
//     super.initState();
//     _loadProperties();
//   }

//   Future<void> _loadProperties() async {
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() {
//       _allProperties.addAll(dummyProperties);
//     });
//   }

//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }

//   List<Property> get _filteredProperties {
//     final selectedCategory = _categories[_selectedCategoryIndex].label;
//     return _allProperties.where((property) {
//       final matchesCategory = property.category == selectedCategory;
//       final matchesSearch = _searchQuery.isEmpty ||
//           property.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           property.location.toLowerCase().contains(_searchQuery.toLowerCase());
//       return matchesCategory && matchesSearch;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: _SearchBar(onChanged: _onSearchChanged),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(120), // Increased height for both category rows
//           child: Column(
//             children: [
//               _buildCategoryIcons(),
//               _buildTotalPriceToggle(),
//             ],
//           ),
//         ),
//       ),
//       body: _allProperties.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : CustomScrollView(
//               slivers: [
//                 SliverPadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) => Padding(
//                         padding: const EdgeInsets.only(bottom: 24),
//                         child: PropertyCard(
//                           property: _filteredProperties[index],
//                           showTotalPrice: _showTotalPrice,
//                           onFavoriteToggle: (prop) {
//                             setState(() {
//                               prop.isFavorite = !prop.isFavorite;
//                             });
//                           },
//                         ),
//                       ),
//                       childCount: _filteredProperties.length,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildCategoryIcons() {
//     return Container(
//       height: 80,
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         scrollDirection: Axis.horizontal,
//         itemCount: _categories.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 24),
//         itemBuilder: (context, index) {
//           final category = _categories[index];
//           final isSelected = _selectedCategoryIndex == index;
//           return GestureDetector(
//             onTap: () => setState(() => _selectedCategoryIndex = index),
//             child: Column(
//               children: [
//                 Icon(
//                   category.icon,
//                   color: isSelected ? const Color(0xFF222222) : const Color(0xFF717171),
//                   size: 28,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   category.label,
//                   style: TextStyle(
//                     color: isSelected ? const Color(0xFF222222) : const Color(0xFF717171),
//                     fontSize: 12,
//                     fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTotalPriceToggle() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Display total price',
//             style: TextStyle(
//               color: Color(0xFF222222),
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           CupertinoSwitch(
//             value: _showTotalPrice,
//             onChanged: (value) => setState(() => _showTotalPrice = value),
//             activeColor: const Color(0xFF222222),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Updated Property Card
// class PropertyCard extends StatelessWidget {
//   final Property property;
//   final bool showTotalPrice;
//   final Function(Property) onFavoriteToggle;

//   const PropertyCard({
//     super.key,
//     required this.property,
//     required this.showTotalPrice,
//     required this.onFavoriteToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => ListingDetailPage(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AspectRatio(
//             aspectRatio: 1,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.asset(
//                     property.images.first,
//                     fit: BoxFit.cover,
//                   ),
//                   if (property.isGuestFavorite)
//                     Positioned(
//                       top: 12,
//                       left: 12,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Text(
//                           'Guest favorite',
//                           style: TextStyle(
//                             color: Color(0xFF222222),
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   Positioned(
//                     top: 12,
//                     right: 12,
//                     child: Container(
//                       // decoration: BoxDecoration(
//                       //   shape: BoxShape.circle,
//                       //   color: Colors.white.withOpacity(0.9),
//                       // ),
//                       child: IconButton(
//                         icon: Icon(
//                           property.isFavorite ? Icons.favorite : Icons.favorite_border,
//                           color: property.isFavorite ? const Color(0xFFFF5A5F) : const Color(0xFF222222),
//                           size: 24,
//                         ),
//                         onPressed: () => onFavoriteToggle(property),
//                       ),
//                     ),
//                   ),
//                   if (property.hasMap)
//                     Positioned(
//                       bottom: 12,
//                       right: 12,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           children: const [
//                             Icon(Icons.map, size: 16),
//                             SizedBox(width: 4),
//                             Text(
//                               'Map',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       property.location,
//                       style: const TextStyle(
//                         color: Color(0xFF222222),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       property.distanceDescription,
//                       style: const TextStyle(
//                         color: Color(0xFF717171),
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       property.availabilityDescription,
//                       style: const TextStyle(
//                         color: Color(0xFF717171),
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     RichText(
//                       text: TextSpan(
//                         style: const TextStyle(color: Color(0xFF222222)),
//                         children: [
//                           TextSpan(
//                             text: showTotalPrice
//                                 ? '₹${property.totalPrice}'
//                                 : '₹${property.price}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const TextSpan(
//                             text: ' night',
//                             style: TextStyle(
//                               color: Color(0xFF717171),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.star,
//                     size: 14,
//                     color: Color(0xFF222222),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     property.rating.toString(),
//                     style: const TextStyle(
//                       color: Color(0xFF222222),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // New Category Item class
// class CategoryItem {
//   final IconData icon;
//   final String label;

//   CategoryItem({required this.icon, required this.label});
// }

// // Search Bar Widget
// class _SearchBar extends StatelessWidget {
//   final Function(String) onChanged;

//   const _SearchBar({required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7F7F7),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: TextField(
//         onChanged: onChanged,
//         decoration: const InputDecoration(
//           hintText: 'Search destinations',
//           prefixIcon: Icon(Icons.search, color: Color(0xFF222222)),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//       ),
//     );
//   }
// }

// // Updated Property Model
// class Property {
//   final String id;
//   final String title;
//   final String location;
//   final double rating;
//   final int price;
//   final int totalPrice;
//   final List<String> images;
//   final String category;
//   final bool isGuestFavorite;
//   final bool hasMap;
//   final String distanceDescription;
//   final String availabilityDescription;
//   bool isFavorite;

//   Property({
//     required this.id,
//     required this.title,
//     required this.location,
//     required this.rating,
//     required this.price,
//     required this.totalPrice,
//     required this.images,
//     required this.category,
//     this.isGuestFavorite = false,
//     this.hasMap = false,
//     required this.distanceDescription,
//     required this.availabilityDescription,
//     this.isFavorite = false,
//   });
// }


// // Service to handle property data
// class PropertiesService {
//   Future<List<Property>> getProperties() async {
//     // TODO: Implement actual data fetching logic
//     // This is a placeholder that returns an empty list
//     return [];
//   }
// }
// final dummyProperties = [
//   // Cars (6 items)
//   Property(
//     id: 'car1',
//     title: 'Sporty Car',
//     location: 'Mumbai, India',
//     rating: 4.5,
//     price: 2000,
//     totalPrice: 2500,
//     images: ['assets/car1.png'],
//     category: 'Cars',
//     isGuestFavorite: true,
//     hasMap: true,
//     distanceDescription: '10 km away',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'car2',
//     title: 'Luxury Sedan',
//     location: 'Delhi, India',
//     rating: 4.8,
//     price: 3000,
//     totalPrice: 3500,
//     images: ['assets/car2.png'],
//     category: 'Cars',
//     isGuestFavorite: false,
//     hasMap: true,
//     distanceDescription: '15 km away',
//     availabilityDescription: 'Available tomorrow',
//   ),
//   Property(
//     id: 'car3',
//     title: 'Convertible',
//     location: 'Bangalore, India',
//     rating: 4.6,
//     price: 2500,
//     totalPrice: 3000,
//     images: ['assets/car3.png'],
//     category: 'Cars',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: '20 km away',
//     availabilityDescription: 'Available next week',
//   ),
//   Property(
//     id: 'car4',
//     title: 'Compact Car',
//     location: 'Hyderabad, India',
//     rating: 4.2,
//     price: 1800,
//     totalPrice: 2200,
//     images: ['assets/car12.png'],
//     category: 'Cars',
//     isGuestFavorite: true,
//     hasMap: true,
//     distanceDescription: '5 km away',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'car5',
//     title: 'Family SUV',
//     location: 'Chennai, India',
//     rating: 4.7,
//     price: 2800,
//     totalPrice: 3300,
//     images: ['assets/car_.jpg'],
//     category: 'Cars',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: '8 km away',
//     availabilityDescription: 'Available this weekend',
//   ),
//   Property(
//     id: 'car6',
//     title: 'Vintage Classic',
//     location: 'Kolkata, India',
//     rating: 4.4,
//     price: 2200,
//     totalPrice: 2700,
//     images: ['assets/car2.png'],
//     category: 'Cars',
//     isGuestFavorite: true,
//     hasMap: true,
//     distanceDescription: '12 km away',
//     availabilityDescription: 'Available soon',
//   ),

//   // Bikes (6 items)
//   Property(
//     id: 'bike1',
//     title: 'Sports Bike',
//     location: 'Mumbai, India',
//     rating: 4.5,
//     price: 1500,
//     totalPrice: 1800,
//     images: ['assets/bike.jpg'],
//     category: 'Bikes',
//     isGuestFavorite: false,
//     hasMap: true,
//     distanceDescription: '8 km away',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'bike2',
//     title: 'Cruiser Bike',
//     location: 'Delhi, India',
//     rating: 4.7,
//     price: 1600,
//     totalPrice: 1900,
//     images: ['assets/bike.jpg'],
//     category: 'Bikes',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: '12 km away',
//     availabilityDescription: 'Available tomorrow',
//   ),
//   Property(
//     id: 'bike3',
//     title: 'Electric Bike',
//     location: 'Bangalore, India',
//     rating: 4.8,
//     price: 1700,
//     totalPrice: 2000,
//     images: ['assets/bike.jpg'],
//     category: 'Bikes',
//     isGuestFavorite: false,
//     hasMap: true,
//     distanceDescription: '10 km away',
//     availabilityDescription: 'Available next week',
//   ),
//   Property(
//     id: 'bike4',
//     title: 'Classic Bike',
//     location: 'Hyderabad, India',
//     rating: 4.3,
//     price: 1400,
//     totalPrice: 1700,
//     images: ['assets/bike.jpg'],
//     category: 'Bikes',
//     isGuestFavorite: false,
//     hasMap: true,
//     distanceDescription: '6 km away',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'bike5',
//     title: 'Adventure Bike',
//     location: 'Chennai, India',
//     rating: 4.6,
//     price: 1550,
//     totalPrice: 1850,
//     images: ['assets/bike.jpg'],
//     category: 'Bikes',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: '9 km away',
//     availabilityDescription: 'Available this weekend',
//   ),
//   Property(
//     id: 'bike6',
//     title: 'Touring Bike',
//     location: 'Kolkata, India',
//     rating: 4.4,
//     price: 1500,
//     totalPrice: 1800,
//     images: ['assets/bike.jpg'],
//     category: 'Bikes',
//     isGuestFavorite: false,
//     hasMap: true,
//     distanceDescription: '11 km away',
//     availabilityDescription: 'Available soon',
//   ),

//   // Laptops (6 items)
//   Property(
//     id: 'laptop1',
//     title: 'Gaming Laptop',
//     location: 'Mumbai, India',
//     rating: 4.9,
//     price: 80000,
//     totalPrice: 85000,
//     images: ['assets/laptop1.png'],
//     category: 'Laptops',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: 'In stock',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'laptop2',
//     title: 'Ultrabook',
//     location: 'Delhi, India',
//     rating: 4.8,
//     price: 75000,
//     totalPrice: 80000,
//     images: ['assets/laptop.png'],
//     category: 'Laptops',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: 'In stock',
//     availabilityDescription: 'Available today',
//   ),
//   Property(
//     id: 'laptop3',
//     title: 'Business Laptop',
//     location: 'Bangalore, India',
//     rating: 4.7,
//     price: 70000,
//     totalPrice: 75000,
//     images: ['assets/laptop1.png'],
//     category: 'Laptops',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: 'In stock',
//     availabilityDescription: 'Available tomorrow',
//   ),
//   Property(
//     id: 'laptop4',
//     title: 'Convertible Laptop',
//     location: 'Hyderabad, India',
//     rating: 4.6,
//     price: 68000,
//     totalPrice: 73000,
//     images: ['assets/laptop.png'],
//     category: 'Laptops',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: 'In stock',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'laptop5',
//     title: '2-in-1 Laptop',
//     location: 'Chennai, India',
//     rating: 4.8,
//     price: 72000,
//     totalPrice: 77000,
//     images: ['assets/laptop1.png'],
//     category: 'Laptops',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: 'In stock',
//     availabilityDescription: 'Available this weekend',
//   ),
//   Property(
//     id: 'laptop6',
//     title: 'Budget Laptop',
//     location: 'Kolkata, India',
//     rating: 4.5,
//     price: 60000,
//     totalPrice: 65000,
//     images: ['assets/laptop.png'],
//     category: 'Laptops',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: 'In stock',
//     availabilityDescription: 'Available soon',
//   ),

//   // Cameras (6 items)
//   Property(
//     id: 'camera1',
//     title: 'DSLR Camera',
//     location: 'Mumbai, India',
//     rating: 4.9,
//     price: 45000,
//     totalPrice: 48000,
//     images: ['assets/cam1.png'],
//     category: 'Cameras',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: 'In store',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'camera2',
//     title: 'Mirrorless Camera',
//     location: 'Delhi, India',
//     rating: 4.8,
//     price: 50000,
//     totalPrice: 53000,
//     images: ['assets/cam3.png'],
//     category: 'Cameras',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: 'In store',
//     availabilityDescription: 'Available today',
//   ),
//   Property(
//     id: 'camera3',
//     title: 'Compact Camera',
//     location: 'Bangalore, India',
//     rating: 4.7,
//     price: 35000,
//     totalPrice: 38000,
//     images: ['assets/cam4.png'],
//     category: 'Cameras',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: 'In store',
//     availabilityDescription: 'Available tomorrow',
//   ),
//   Property(
//     id: 'camera4',
//     title: 'Action Camera',
//     location: 'Hyderabad, India',
//     rating: 4.6,
//     price: 30000,
//     totalPrice: 33000,
//     images: ['assets/cam78.png'],
//     category: 'Cameras',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: 'In store',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'camera5',
//     title: 'Film Camera',
//     location: 'Chennai, India',
//     rating: 4.5,
//     price: 28000,
//     totalPrice: 31000,
//     images: ['assets/cam1.png'],
//     category: 'Cameras',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: 'In store',
//     availabilityDescription: 'Available this weekend',
//   ),
//   Property(
//     id: 'camera6',
//     title: 'Point & Shoot',
//     location: 'Kolkata, India',
//     rating: 4.4,
//     price: 22000,
//     totalPrice: 25000,
//     images: ['assets/cam3.png'],
//     category: 'Cameras',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: 'In store',
//     availabilityDescription: 'Available soon',
//   ),

//   // Houses (6 items)
//   Property(
//     id: 'house1',
//     title: 'Modern Farm House',
//     location: 'Coimbatore, India',
//     rating: 4.9,
//     price: 1836,
//     totalPrice: 2500,
//     images: ['assets/nat1.png'],
//     category: 'Houses',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: '259 km away',
//     availabilityDescription: '5-9 Apr',
//   ),
//   Property(
//     id: 'house2',
//     title: 'Beachfront Villa',
//     location: 'Goa, India',
//     rating: 4.8,
//     price: 2549,
//     totalPrice: 3200,
//     images: ['assets/nat2.png'],
//     category: 'Houses',
//     isGuestFavorite: false,
//     hasMap: true,
//     distanceDescription: '200 km away',
//     availabilityDescription: '10-15 Apr',
//   ),
//   Property(
//     id: 'house3',
//     title: 'Mountain Cabin',
//     location: 'Himalayas, India',
//     rating: 4.7,
//     price: 1899,
//     totalPrice: 2600,
//     images: ['assets/nat2.png'],
//     category: 'Houses',
//     isGuestFavorite: false,
//     hasMap: false,
//     distanceDescription: '300 km away',
//     availabilityDescription: '15-20 Apr',
//   ),
//   Property(
//     id: 'house4',
//     title: 'Luxury Apartment',
//     location: 'Mumbai, India',
//     rating: 4.9,
//     price: 3249,
//     totalPrice: 4000,
//     images: ['assets/nat3.png'],
//     category: 'Houses',
//     isGuestFavorite: true,
//     hasMap: true,
//     distanceDescription: '5 km away',
//     availabilityDescription: 'Available now',
//   ),
//   Property(
//     id: 'house5',
//     title: 'Urban Condo',
//     location: 'Bangalore, India',
//     rating: 4.6,
//     price: 2900,
//     totalPrice: 3500,
//     images: ['assets/nat4.png'],
//     category: 'Houses',
//     isGuestFavorite: false,
//     hasMap: true,
//     distanceDescription: '3 km away',
//     availabilityDescription: 'Available today',
//   ),
//   Property(
//     id: 'house6',
//     title: 'Suburban Home',
//     location: 'Chennai, India',
//     rating: 4.5,
//     price: 2100,
//     totalPrice: 2700,
//     images: ['assets/nat5.png'],
//     category: 'Houses',
//     isGuestFavorite: true,
//     hasMap: false,
//     distanceDescription: '8 km away',
//     availabilityDescription: 'Available this weekend',
//   ),
// ];
