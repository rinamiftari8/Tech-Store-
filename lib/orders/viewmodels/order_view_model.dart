import 'package:tech_store/modules/orders/models/order.dart';
import 'package:tech_store/modules/products/models/product.dart';

class OrderViewModel {
  Order createCompletedOrder({
    required int id,
    required List<Product> items,
    required double total,
  }) {
    return Order(
      id: id,
      items: items,
      total: total,
      date: DateTime.now().toString(),
    );
  }

  double calculateTotalRevenue(List<Order> orders) {
    double revenue = 0;

    for (final Order order in orders) {
      revenue += order.total;
    }

    return revenue;
  }

  int calculateCompletedOrders(List<Order> orders) {
    return orders.length;
  }
}