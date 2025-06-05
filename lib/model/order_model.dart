class OrderModel {
  final String orderId;
  final String title;
  final int items;
  final double price;
  final String status;
  final String imageUrl;

  OrderModel({
    required this.orderId,
    required this.title,
    required this.items,
    required this.price,
    required this.status,
    required this.imageUrl,
  });
}
