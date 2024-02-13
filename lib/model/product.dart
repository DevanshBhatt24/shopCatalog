class Product {
  final int id;
  final String title;
  final String image;
  final dynamic price;
  final String description;
  bool isOnCart;
  Product(
      {required this.id,
      required this.title,
      required this.image,
      required this.price,
      required this.description,
      required this.isOnCart});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        price: json["price"],
        description: json["description"],
        isOnCart: false);
  }
}
