
import 'package:flutter/material.dart';

class Category {
  final String categoryId;
  final String name;
  final IconData icon;

  Category({
    required this.categoryId,
    required this.name,
    required this.icon,
  });
}

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final ScrollController _scrollController = ScrollController();
  String _activeCategory = '';
  bool _showLeftButton = false;
  bool _showRightButton = true;

  // Sample categories data
  final List<Category> categories = [
    Category(categoryId: '1', name: 'Electronics', icon: Icons.monitor),
    Category(categoryId: '2', name: 'Furniture', icon: Icons.chair),
    Category(categoryId: '3', name: 'Vehicles', icon: Icons.local_shipping),
    Category(categoryId: '4', name: 'Bikes', icon: Icons.pedal_bike),
    Category(categoryId: '5', name: 'Books', icon: Icons.book),
    Category(categoryId: '6', name: 'Clothing', icon: Icons.checkroom),
    Category(categoryId: '7', name: 'Sports', icon: Icons.sports),
    Category(categoryId: '8', name: 'Tools', icon: Icons.build),
    Category(categoryId: '9', name: 'Games', icon: Icons.games),
    Category(categoryId: '10', name: 'Kitchen', icon: Icons.kitchen),
    Category(categoryId: '11', name: 'Home Decor', icon: Icons.home),
    Category(categoryId: '12', name: 'Music', icon: Icons.music_note),
    Category(categoryId: '13', name: 'Camera', icon: Icons.camera_alt),
    Category(categoryId: '14', name: 'Travel', icon: Icons.flight),
    Category(categoryId: '15', name: 'Fitness', icon: Icons.fitness_center),
  ];

  @override
  void initState() {
    super.initState();
    _activeCategory = categories.first.categoryId;
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    setState(() {
      _showLeftButton = _scrollController.offset > 0;
      _showRightButton = _scrollController.offset <
          _scrollController.position.maxScrollExtent - 10;
    });
  }

  void _scroll(String direction) {
    double scrollAmount = MediaQuery.of(context).size.width * 0.6;
    if (scrollAmount > 300) scrollAmount = 300;

    double targetScroll = _scrollController.offset +
        (direction == "left" ? -scrollAmount : scrollAmount);

    _scrollController.animateTo(
      targetScroll,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                children: categories.map((category) => _buildCategoryItem(category)).toList(),
              ),
            ),
          ),
          if (_showLeftButton)
            Positioned(
              left: -4,
              top: 0,
              bottom: 0,
              child: _buildScrollButton(Icons.chevron_left, "left"),
            ),
          if (_showRightButton)
            Positioned(
              right: -4,
              top: 0,
              bottom: 0,
              child: _buildScrollButton(Icons.chevron_right, "right"),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Category category) {
    bool isActive = category.categoryId == _activeCategory;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeCategory = category.categoryId;
        });
        // Navigate to category page
        // Navigator.pushNamed(context, '/categories/${category.categoryId}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        constraints: const BoxConstraints(
          minWidth: 72,
          maxWidth: 88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.grey.shade200 : Colors.transparent,
              ),
              child: Icon(
                category.icon,
                size: 24,
                color: isActive ? const Color.fromARGB(255, 240, 0, 0) : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color.fromARGB(255, 0, 255, 106) : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isActive ? 32 : 0,
              color: isActive ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollButton(IconData icon, String direction) {
    return Center(
      child: MaterialButton(
        onPressed: () => _scroll(direction),
        color: Colors.white,
        elevation: 4,
        highlightElevation: 8,
        padding: EdgeInsets.zero,
        minWidth: 32,
        height: 32,
        shape: const CircleBorder(),
        child: Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}