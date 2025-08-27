class CategoryItem {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final String image;
  final double rating;
  final double tax;
  final double deliveryFee;

  CategoryItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
    required this.tax,
    required this.deliveryFee,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price'],
      image: json['image'],
      rating: json['rating'],
      tax: json['tax'],
      deliveryFee: json['delivery_fee'],
    );
  }
}
