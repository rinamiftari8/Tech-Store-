import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../bookings/viewmodels/booking_view_model.dart';
import '../../cart/viewmodels/cart_view_model.dart';
import '../../orders/viewmodels/order_view_model.dart';
import '../../products/viewmodels/product_view_model.dart';
import '../../tasks/viewmodels/task_view_model.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductViewModel>().products.length;
    final cart = context.watch<CartViewModel>();
    final orders = context.watch<OrderViewModel>();
    final bookings = context.watch<BookingViewModel>().bookings.length;
    final tasks = context.watch<TaskViewModel>();

    final values = <_ChartValue>[
      _ChartValue('Products', products.toDouble()),
      _ChartValue('Cart', cart.itemCount.toDouble()),
      _ChartValue('Orders', orders.orders.length.toDouble()),
      _ChartValue('Bookings', bookings.toDouble()),
      _ChartValue('Tasks', tasks.tasks.length.toDouble()),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Analytics dashboard', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 760;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: wide ? 4 : 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: wide ? 2.2 : 1.45,
                children: [
                  StatCard(title: 'Products', value: '$products', icon: Icons.devices_rounded, subtitle: 'From REST API'),
                  StatCard(title: 'Cart Items', value: '${cart.itemCount}', icon: Icons.shopping_cart_rounded),
                  StatCard(title: 'Orders', value: '${orders.orders.length}', icon: Icons.receipt_long_rounded),
                  StatCard(title: 'Revenue', value: '\$${orders.revenue.toStringAsFixed(0)}', icon: Icons.payments_rounded),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Module activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 20),
                  _SimpleBarChart(values: values),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.task_alt_rounded, color: AppColors.primary, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Task completion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: tasks.tasks.isEmpty ? 0 : tasks.completedCount / tasks.tasks.length,
                          minHeight: 12,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        const SizedBox(height: 8),
                        Text('${tasks.completedCount} of ${tasks.tasks.length} tasks completed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartValue {
  const _ChartValue(this.label, this.value);
  final String label;
  final double value;
}

class _SimpleBarChart extends StatelessWidget {
  const _SimpleBarChart({required this.values});

  final List<_ChartValue> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.fold<double>(1, (max, item) => item.value > max ? item.value : max);
    return Column(
      children: values.map((item) {
        final percent = item.value / maxValue;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              SizedBox(width: 86, child: Text(item.label)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 18,
                    backgroundColor: AppColors.lightGreen,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(width: 40, child: Text(item.value.toStringAsFixed(0))),
            ],
          ),
        );
      }).toList(),
    );
  }
}
