import '../../cart/models/cart_item.dart';

class StoreOrder {
  const StoreOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final String status;
}
