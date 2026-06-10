import 'package:flutter/foundation.dart';

import '../../products/models/product.dart';
import '../models/cart_item.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  void addProduct(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _items.add(CartItem(product: product, quantity: 1));
    } else {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) return;
    if (_items[index].quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity - 1);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
