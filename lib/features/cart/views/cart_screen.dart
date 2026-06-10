import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../notifications/viewmodels/notification_view_model.dart';
import '../../orders/viewmodels/order_view_model.dart';
import '../viewmodels/cart_view_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_checkout_rounded, color: AppColors.primary, size: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your cart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                      Text('${cart.itemCount} items selected'),
                    ],
                  ),
                ),
                Text(
                  '\$${cart.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (cart.items.isEmpty)
          const _EmptyCart()
        else ...[
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      color: AppColors.lightGreen,
                      width: 62,
                      height: 62,
                      child: Image.network(item.product.image, fit: BoxFit.contain),
                    ),
                  ),
                  title: Text(item.product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Quantity: ${item.quantity} • \$${item.subtotal.toStringAsFixed(2)}'),
                  trailing: Wrap(
                    spacing: 6,
                    children: [
                      IconButton(
                        onPressed: () => context.read<CartViewModel>().decrease(item.product),
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                      ),
                      IconButton(
                        onPressed: () => context.read<CartViewModel>().addProduct(item.product),
                        icon: const Icon(Icons.add_circle_outline_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              final createdOrder = context.read<OrderViewModel>().createOrder(cart.items, cart.total);
              context.read<CartViewModel>().clear();
              context.read<NotificationViewModel>().push(
                    title: 'Order created',
                    message: '${createdOrder.id} is now processing.',
                    type: 'Order',
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order ${createdOrder.id} created.')),
              );
            },
            icon: const Icon(Icons.payments_rounded),
            label: const Text('Checkout order'),
          ),
        ],
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: const [
            Icon(Icons.shopping_bag_outlined, size: 70, color: AppColors.primary),
            SizedBox(height: 14),
            Text('Cart is empty', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            SizedBox(height: 6),
            Text('Add products from the product catalog.'),
          ],
        ),
      ),
    );
  }
}
