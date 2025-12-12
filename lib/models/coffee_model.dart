class Coffee {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;

  Coffee({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unnamed Product',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      description:
          json['description']?.toString() ?? 'No description available',
      category: json['category']?.toString() ?? 'Coffee',
    );
  }
}
