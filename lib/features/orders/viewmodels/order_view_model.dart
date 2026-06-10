import 'package:flutter/foundation.dart';

import '../../cart/models/cart_item.dart';
import '../models/order.dart';

class OrderViewModel extends ChangeNotifier {
  final List<StoreOrder> _orders = [];

  List<StoreOrder> get orders => List.unmodifiable(_orders);
  double get revenue => _orders.fold(0, (sum, order) => sum + order.total);

  StoreOrder createOrder(List<CartItem> items, double total) {
    final order = StoreOrder(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List<CartItem>.from(items),
      total: total,
      createdAt: DateTime.now(),
      status: 'Processing',
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}
