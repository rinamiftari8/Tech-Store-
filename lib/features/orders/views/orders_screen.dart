import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../viewmodels/order_view_model.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderViewModel>().orders;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Order history', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        if (orders.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Center(child: Text('No orders yet. Checkout your cart to create the first order.')),
            ),
          )
        else
          ...orders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.lightGreen,
                    child: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  ),
                  title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text('${DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt)} • ${order.status}'),
                  trailing: Text('\$${order.total.toStringAsFixed(2)}'),
                  children: order.items
                      .map(
                        (item) => ListTile(
                          title: Text(item.product.title),
                          subtitle: Text('Qty: ${item.quantity}'),
                          trailing: Text('\$${item.subtotal.toStringAsFixed(2)}'),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
