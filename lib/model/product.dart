class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final List<dynamic> category;
  final String image;
  final Map<String, dynamic> specifications;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.specifications,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id']),
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'] ?? [],
      image: json['image'],
      specifications: json['specifications'] ?? {},
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "category": category,
      "image": image,
      "specifications": specifications,
      "stock": stock,
    };
  }
}
