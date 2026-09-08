class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.colors,
    required this.isNew,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  final List<String> colors;
  final bool isNew;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      colors: (json['colors'] as List<dynamic>).cast<String>(),
      isNew: json['isNew'] as bool? ?? false,
    );
  }
}