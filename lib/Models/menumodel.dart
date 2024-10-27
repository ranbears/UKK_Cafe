class MenuItem {
  String id;
  String name;
  String category;
  double price; // Use double for better numerical handling
  String info;
  String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.info,
    required this.imageUrl,
  });

  // CopyWith method
  MenuItem copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? info,
    String? imageUrl,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      info: info ?? this.info,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Function to convert data from JSON to object
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0, // Convert to double
      info: map['info'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Function to convert object to JSON format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'info': info,
      'imageUrl': imageUrl,
    };
  }
}
