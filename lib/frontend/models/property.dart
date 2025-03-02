// property.dart
class Property {
  final String id;
  final String title;
  final String location;
  final double rating;
  final int price;
  final int totalPrice;
  final List<String> images;
  final String category;
  final bool isGuestFavorite;
  final bool hasMap;
  final String distanceDescription;
  final String availabilityDescription;
  bool isFavorite;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
    required this.totalPrice,
    required this.images,
    required this.category,
    this.isGuestFavorite = false,
    this.hasMap = false,
    required this.distanceDescription,
    required this.availabilityDescription,
    this.isFavorite = false,
  });
  
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
