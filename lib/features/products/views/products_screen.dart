import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../cart/viewmodels/cart_view_model.dart';
import '../../notifications/viewmodels/notification_view_model.dart';
import '../models/product.dart';
import '../viewmodels/product_view_model.dart';
import 'product_details_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.softBackground,
      ),
      child: RefreshIndicator(
        onRefresh: () => context.read<ProductViewModel>().loadProducts(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroBanner(),
                    const SizedBox(height: 18),
                    _QuickStats(totalProducts: vm.products.length),
                    const SizedBox(height: 18),
                    _SearchAndFilter(
                      onSearch: context.read<ProductViewModel>().search,
                    ),
                    const SizedBox(height: 18),
                    const _CategoryChips(),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
            if (vm.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (vm.products.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No products found.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.crossAxisExtent;

                    final crossAxisCount = width >= 1200
                        ? 4
                        : width >= 880
                            ? 3
                            : width >= 560
                                ? 2
                                : 1;

                    final aspectRatio = crossAxisCount == 1
                        ? 0.82
                        : crossAxisCount == 2
                            ? 0.68
                            : 0.66;

                    return SliverGrid.builder(
                      itemCount: vm.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        return _ProductCard(
                          product: vm.products[index],
                          index: index,
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;

        return Container(
          height: compact ? 360 : 290,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            boxShadow: SoftShadow.strong,
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1518770660439-4636190af475?w=1600&auto=format&fit=crop',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDeep.withOpacity(0.94),
                  AppColors.primaryDark.withOpacity(0.78),
                  Colors.black.withOpacity(0.22),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: EdgeInsets.all(compact ? 22 : 30),
            child: compact
                ? const _HeroContent(compact: true)
                : const Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: _HeroContent(compact: false),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        flex: 3,
                        child: _HeroGlassCard(),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: compact ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.22),
            ),
          ),
          child: const Text(
            'NEW TECHNOLOGY 2026',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 0.9,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Discover premium devices for work, gaming and smart living.',
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 27 : 36,
            fontWeight: FontWeight.w900,
            height: 1.05,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Laptops, smartphones, drones, AI accessories, cameras, wearables and smart home devices in one professional dashboard.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.78),
            height: 1.48,
            fontSize: compact ? 13.5 : 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 22),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _HeroChip(
              icon: Icons.bolt_rounded,
              label: 'Fast Checkout',
            ),
            _HeroChip(
              icon: Icons.verified_rounded,
              label: 'Warranty',
            ),
            _HeroChip(
              icon: Icons.local_shipping_rounded,
              label: 'Smart Delivery',
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroGlassCard extends StatelessWidget {
  const _HeroGlassCard();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withOpacity(0.22),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 92,
              width: 92,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 54,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Tech Store Pro',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 21,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Premium technology shopping experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.totalProducts});

  final int totalProducts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;

        final children = [
          _StatTile(
            icon: Icons.inventory_2_rounded,
            label: 'Products',
            value: totalProducts.toString(),
          ),
          const _StatTile(
            icon: Icons.category_rounded,
            label: 'Categories',
            value: '10+',
          ),
          const _StatTile(
            icon: Icons.star_rounded,
            label: 'Avg Rating',
            value: '4.8',
          ),
          const _StatTile(
            icon: Icons.support_agent_rounded,
            label: 'Support',
            value: '24/7',
          ),
        ];

        if (compact) {
          return Column(
            children: children
                .map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: child,
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: children
              .map(
                (child) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: child,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: SoftShadow.medium,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({required this.onSearch});

  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onSearch,
            decoration: const InputDecoration(
              hintText: 'Search laptops, phones, drones, cameras...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: SoftShadow.medium,
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    const categories = [
      ['Laptops', Icons.laptop_mac_rounded],
      ['Phones', Icons.phone_iphone_rounded],
      ['Gaming', Icons.sports_esports_rounded],
      ['Audio', Icons.headphones_rounded],
      ['Cameras', Icons.photo_camera_rounded],
      ['Drones', Icons.flight_takeoff_rounded],
      ['Smart Home', Icons.home_max_rounded],
      ['Wearables', Icons.watch_rounded],
      ['VR', Icons.view_in_ar_rounded],
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((item) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  item[1] as IconData,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  item[0] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.index,
  });

  final Product product;
  final int index;

  @override
  Widget build(BuildContext context) {
    final badge = _badgeForIndex(index);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
        boxShadow: SoftShadow.medium,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppColors.lightGreen,
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: AppColors.lightGreen,
                                child: const Icon(
                                  Icons.image_not_supported_rounded,
                                  size: 44,
                                  color: AppColors.muted,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: _SmallBadge(
                          text: badge,
                          background: Colors.white.withOpacity(0.94),
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.48),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.warning,
                                size: 15,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  product.category.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.5,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16.5,
                    color: AppColors.text,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 43,
                      width: 43,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.read<CartViewModel>().addProduct(product);

                          context.read<NotificationViewModel>().push(
                                title: 'Added to cart',
                                message: '${product.title} was added to your cart.',
                                type: 'Cart',
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.title} added to cart.'),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add_shopping_cart_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _badgeForIndex(int index) {
    if (index == 0) return 'BEST SELLER';
    if (index == 1) return 'NEW TECH';
    if (index == 2) return 'FEATURED';
    if (index == 3) return 'POPULAR';
    return 'PREMIUM';
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({
    required this.text,
    required this.background,
    required this.color,
  });

  final String text;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
