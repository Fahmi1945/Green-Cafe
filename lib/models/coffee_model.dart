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
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['imageUrl'],
      description: json['description'],
      category: json['category']?.toString() ?? 'Coffee',
    );
  }
}