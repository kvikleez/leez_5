// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';



// class WishlistsScreen extends StatefulWidget {
//   const WishlistsScreen({super.key});

//   @override
//   State<WishlistsScreen> createState() => _WishlistsScreenState();
// }

// class _WishlistsScreenState extends State<WishlistsScreen> {
//   final List<WishlistCategory> _wishlistCategories = [
//     WishlistCategory(
//       title: "Recently viewed",
//       previewImages: List.generate(4, (i) => "https://picsum.photos/200?image=$i"),
//       lastUpdated: "2 weeks ago",
//     ),
//     WishlistCategory(
//       title: "Summer Breaks",
//       previewImages: List.generate(4, (i) => "https://picsum.photos/200?beach=$i"),
//       lastUpdated: "1 month ago",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wishlists", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text("Edit", style: TextStyle(color: Colors.black)),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: _wishlistCategories.length,
//         itemBuilder: (context, index) => _buildCategoryTile(
//           context,
//           _wishlistCategories[index],
//           screenWidth,
//           isPortrait,
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryTile(BuildContext context, WishlistCategory category, 
//       double screenWidth, bool isPortrait) {
//     return InkWell(
//       onTap: () => _handleCategoryTap(context, category),
//       child: Container(
//         margin: EdgeInsets.symmetric(
//           horizontal: screenWidth * 0.04,
//           vertical: screenWidth * 0.02,
//         ),
//         padding: EdgeInsets.all(screenWidth * 0.03),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Row(
//           children: [
//             _buildPreviewGrid(category.previewImages, screenWidth),
//             SizedBox(width: screenWidth * 0.04),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     category.title,
//                     style: TextStyle(
//                       fontSize: isPortrait ? 16 : 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: screenWidth * 0.01),
//                   Text(
//                     category.lastUpdated,
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: isPortrait ? 14 : 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPreviewGrid(List<String> images, double screenWidth) {
//     return SizedBox(
//       width: screenWidth * 0.2,
//       height: screenWidth * 0.2,
//       child: GridView.count(
//         crossAxisCount: 2,
//         mainAxisSpacing: 2,
//         crossAxisSpacing: 2,
//         physics: const NeverScrollableScrollPhysics(),
//         children: images.take(4).map((url) => _buildGridItem(url)).toList(),
//       ),
//     );
//   }

//   Widget _buildGridItem(String imageUrl) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   void _handleCategoryTap(BuildContext context, WishlistCategory category) {
//     if (category.title == "Recently viewed") {
//       Navigator.push(context, MaterialPageRoute(
//         builder: (_) => const RecentlyViewedScreen()));
//     }
//   }
// }

// class RecentlyViewedScreen extends StatelessWidget {
//   const RecentlyViewedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Recently viewed"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text("Edit", style: TextStyle(color: Colors.black)),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//         children: List.generate(4, (index) => _buildProductItem(context, index)),
//       ),
//     );
//   }

//   Widget _buildProductItem(BuildContext context, int index) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return InkWell(
//       onTap: () => Navigator.push(context, MaterialPageRoute(
//         builder: (_) => ProductDetailScreen(
//           product: ProductItem(
//             title: "Property ${index + 1}",
//             location: "Location ${index + 1}",
//             rating: 4.5 + (index * 0.1),
//             beds: 2 + index,
//             imageUrl: "https://picsum.photos/400?image=$index",
//             dateViewed: DateTime.now(),
//           ),
//         ),
//       )),
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 "https://picsum.photos/400?image=$index",
//                 width: screenWidth * 0.25,
//                 height: screenWidth * 0.2,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(width: screenWidth * 0.04),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Property ${index + 1}",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: screenWidth * 0.04,
//                     ),
//                   ),
//                   SizedBox(height: screenWidth * 0.01),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.04),
//                       SizedBox(width: screenWidth * 0.01),
//                       Text(
//                         "${4.5 + (index * 0.1)}",
//                         style: TextStyle(fontSize: screenWidth * 0.035),
//                       ),
//                       SizedBox(width: screenWidth * 0.04),
//                       Text(
//                         "${2 + index} beds",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: screenWidth * 0.035,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: Icon(Iconsax.heart, size: screenWidth * 0.06),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProductDetailScreen extends StatelessWidget {
//   final ProductItem product;

//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product.title),
//         actions: [
//           IconButton(
//             icon: const Icon(Iconsax.heart),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               product.imageUrl,
//               width: double.infinity,
//               height: isPortrait ? screenWidth * 0.6 : screenWidth * 0.4,
//               fit: BoxFit.cover,
//             ),
//             Padding(
//               padding: EdgeInsets.all(screenWidth * 0.04),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.title,
//                     style: TextStyle(
//                       fontSize: isPortrait ? 24 : 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: screenWidth * 0.02),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.05),
//                       SizedBox(width: screenWidth * 0.02),
//                       Text(
//                         product.rating.toString(),
//                         style: TextStyle(fontSize: screenWidth * 0.04),
//                       ),
//                       SizedBox(width: screenWidth * 0.04),
//                       Text(
//                         "${product.beds} beds",
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.04,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: screenWidth * 0.04),
//                   Text(
//                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       height: 1.5,
//                     ),
//                   ),
//                   SizedBox(height: screenWidth * 0.04),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
//                         child: Text(
//                           "Book Now",
//                           style: TextStyle(fontSize: screenWidth * 0.04),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class WishlistCategory {
//   final String title;
//   final List<String> previewImages;
//   final String lastUpdated;

//   WishlistCategory({
//     required this.title,
//     required this.previewImages,
//     required this.lastUpdated,
//   });
// }

// class ProductItem {
//   final String title;
//   final String location;
//   final double rating;
//   final int beds;
//   final String imageUrl;
//   final DateTime dateViewed;

//   ProductItem({
//     required this.title,
//     required this.location,
//     required this.rating,
//     required this.beds,
//     required this.imageUrl,
//     required this.dateViewed,
//   });
// }