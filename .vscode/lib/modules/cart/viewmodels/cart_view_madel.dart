import 'package:tech_store/modules/products/models/product.dart';

class CartViewModel {
  double calculateCartTotal(List<Product> cartItems) {
    double total = 0;

    for (final Product product in cartItems) {
      total += product.price;
    }

    return total;
  }

  int calculateCartItems(List<Product> cartItems) {
    return cartItems.length;
  }

  bool isCartEmpty(List<Product> cartItems) {
    return cartItems.isEmpty;
  }
}

