class CartItem {
  final String id;
  final String categoryId;
  final String title;
  final String imageUrl;
  final double price;

  final double itemTax;

  final double handlingFee;
  int quantity;

  CartItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.itemTax,
    required this.handlingFee,
    this.quantity = 1,
  });
}
