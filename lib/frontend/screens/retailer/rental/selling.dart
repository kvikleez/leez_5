import 'package:flutter/material.dart';

// Simple data model to represent a product.
class Product {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final List<String> badges; // e.g. ["New", "Featured"], or ["Used", "Like New"]
  final bool isAvailable;    // true => "Available", false => "Sold Out"

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.badges,
    required this.isAvailable,
  });
}



/// The main home page with SliverAppBar, TabBar, and a FAB.
class SellingScreen extends StatefulWidget {
  const SellingScreen({super.key});

  @override
  State<SellingScreen> createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample data for the "Basic" tab
  final List<Product> _basicProducts = [
    Product(
      id: 'p1',
      name: 'Vintage Leather Messenger Bag',
      price: 189.99,
      imagePath: 'assets/car4.jpg', // Make sure to add this image to assets
      badges: ['New', 'Featured'],
      isAvailable: true,
    ),
    Product(
      id: 'p2',
      name: 'Premium Smart Watch Pro',
      price: 299.99,
      imagePath: 'assets/car4.jpg', // Make sure to add this image to assets
      badges: ['New', 'Boosted'],
      isAvailable: true,
    ),
    Product(
      id: 'p3',
      name: 'Wireless Noise-Cancelling Headphones',
      price: 249.99,
      imagePath: 'assets/car4.jpg', // Add to assets
      badges: ['Used', 'Like New'],
      isAvailable: false,
    ),
  ];

  // Sample data for the "Boosted" tab
  final List<Product> _boostedProducts = [
    Product(
      id: 'p4',
      name: '4K Ultra HD Drone',
      price: 449.99,
      imagePath: 'assets/car4.jpg', // Add to assets
      badges: ['New', 'Featured'],
      isAvailable: true,
    ),
    Product(
      id: 'p5',
      name: 'Professional DSLR Camera',
      price: 999.99,
      imagePath: 'assets/car4.jpg', // Add to assets
      badges: ['Like New'],
      isAvailable: true,
    ),
    Product(
      id: 'p6',
      name: 'Gaming Laptop i9 Series',
      price: 1999.00,
      imagePath: 'assets/car4.jpg', // Add to assets
      badges: ['Boosted'],
      isAvailable: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Two tabs: Basic and Boosted
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Builds each tab's product list.
  Widget _buildProductList(List<Product> products) {
    return CustomScrollView(
      // Let the SliverAppBar collapse properly
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a NestedScrollView for a pinned SliverAppBar with a TabBar
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // SliverAppBar that collapses
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 120,
              backgroundColor: Colors.white,
              elevation: 1,
              title: const Text(
                'Products',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              // TabBar goes in the bottom property
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: const [
                      Tab(text: 'Basic'),
                      Tab(text: 'Boosted'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        // The body is a TabBarView with each product list
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProductList(_basicProducts),
            _buildProductList(_boostedProducts),
          ],
        ),
      ),
      // Floating Action Button (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example: Add new product, or open a form
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FAB tapped! Add new product here.')),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

/// A single product card that shows:
///  • Image on the left
///  • Name, price
///  • Badges, e.g. "New", "Featured", etc.
///  • Availability: "Available" (green) or "Sold Out" (red)
/// Tapping on the card navigates to ProductDetailPage with a Hero animation.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Example availability text
    final availabilityText = product.isAvailable ? 'Available' : 'Sold Out';
    final availabilityColor = product.isAvailable ? Colors.green : Colors.red;

    return InkWell(
      onTap: () {
        // Navigate to detail page with Hero animation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Hero animation for the product image
            Hero(
              tag: 'hero-${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  product.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Badges row
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: product.badges
                        .map(
                          (badge) => _buildBadge(badge),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            // Availability text on the far right
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  availabilityText,
                  style: TextStyle(
                    color: availabilityColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Simple badge design
  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

/// A detail page that displays a larger product image, name, price, badges, etc.
class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final availabilityText = product.isAvailable ? 'Available' : 'Sold Out';
    final availabilityColor = product.isAvailable ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Hero animation for the product image
            Hero(
              tag: 'hero-${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.imagePath,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Name & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Availability
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                availabilityText,
                style: TextStyle(
                  color: availabilityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Badges
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: product.badges
                  .map(
                    (badge) => _buildBadge(badge),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            // Example product description
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Aliquam commodo efficitur quam in porta. Vestibulum ac '
              'ullamcorper nulla, quis bibendum ex. Pellentesque habitant '
              'morbi tristique senectus et netus et malesuada fames ac turpis egestas. '
              'Proin tristique, dui id blandit pretium, nisi nisl faucibus nisl, '
              'in blandit tortor ipsum non urna. Duis ultricies nisi eget metus lobortis luctus.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Example: Add to cart, or rent product, etc.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "${product.name}" to cart!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Same badge style used in ProductCard
  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
