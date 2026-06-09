import 'package:tech_store/modules/products/models/product.dart';

class Order {
  final int id;
  final List<Product> items;
  final double total;
  final String date;

  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
  });
}

