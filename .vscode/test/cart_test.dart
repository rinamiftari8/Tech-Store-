import 'package:flutter_test/flutter_test.dart';

class TestProduct {
  final String name;
  final double price;

  const TestProduct({
    required this.name,
    required this.price,
  });
}

double calculateCartTotal(List<TestProduct> cart) {
  double total = 0;

  for (final product in cart) {
    total += product.price;
  }

  return total;
}

void main() {
  test('Cart total should be calculated correctly', () {
    final cart = [
      const TestProduct(name: 'MacBook Pro', price: 1299),
      const TestProduct(name: 'AirPods Pro', price: 249),
      const TestProduct(name: 'Smart Watch', price: 399),
    ];

    final total = calculateCartTotal(cart);

    expect(total, 1947);
  });

  test('Empty cart total should be zero', () {
    final cart = <TestProduct>[];

    final total = calculateCartTotal(cart);

    expect(total, 0);
  });
}
