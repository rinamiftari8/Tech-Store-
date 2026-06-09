import 'package:flutter/material.dart';

void main() {
  runApp(const TechStoreApp());
}

class TechStoreApp extends StatelessWidget {
  const TechStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Store Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEAF3EF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF24664B),
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}

class Product {
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final String badge;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.badge,
  });
}

const List<Product> allProducts = [
  Product(
    name: 'MacBook Pro',
    category: 'Laptop',
    price: 1299,
    badge: 'Popular',
    description: 'Powerful laptop for programming, design, school and work.',
    imageUrl:
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Ultra Slim Laptop',
    category: 'Laptop',
    price: 999,
    badge: 'New',
    description: 'Lightweight laptop with modern design and strong battery.',
    imageUrl:
        'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'iPhone 15',
    category: 'Phone',
    price: 899,
    badge: 'Hot',
    description: 'Modern smartphone with smooth performance and great camera.',
    imageUrl:
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Foldable Phone',
    category: 'Phone',
    price: 1199,
    badge: 'Premium',
    description: 'Flexible screen smartphone made for multitasking.',
    imageUrl:
        'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Smart Watch',
    category: 'Watch',
    price: 399,
    badge: 'New',
    description: 'Smart watch for health, fitness and notifications.',
    imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30a?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'AirPods Pro',
    category: 'Audio',
    price: 249,
    badge: 'Best Seller',
    description: 'Wireless earbuds with clean sound and noise control.',
    imageUrl:
        'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Wireless Headphones',
    category: 'Audio',
    price: 199,
    badge: 'Comfort',
    description: 'Comfortable headphones for music, gaming and calls.',
    imageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Gaming PC',
    category: 'Desktop',
    price: 1499,
    badge: 'Gaming',
    description: 'Fast desktop computer for gaming, editing and work.',
    imageUrl:
        'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Curved Monitor',
    category: 'Monitor',
    price: 449,
    badge: '4K',
    description: 'Large display for productivity, movies and gaming.',
    imageUrl:
        'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'VR Headset',
    category: 'Virtual Reality',
    price: 699,
    badge: 'Future Tech',
    description: 'Immersive headset for games, learning and virtual worlds.',
    imageUrl:
        'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Drone Camera',
    category: 'Drone',
    price: 799,
    badge: 'Camera',
    description: 'Smart drone with camera for travel videos and photos.',
    imageUrl:
        'https://images.unsplash.com/photo-1473968512647-3e447244af8f?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Digital Camera',
    category: 'Camera',
    price: 649,
    badge: 'Creator',
    description: 'Camera for content creators, photos and video projects.',
    imageUrl:
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Tablet Pro',
    category: 'Tablet',
    price: 599,
    badge: 'Study',
    description: 'Portable tablet for notes, school and entertainment.',
    imageUrl:
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Mechanical Keyboard',
    category: 'Accessories',
    price: 129,
    badge: 'RGB',
    description: 'Modern keyboard for coding, gaming and fast typing.',
    imageUrl:
        'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Wireless Mouse',
    category: 'Accessories',
    price: 79,
    badge: 'Wireless',
    description: 'Smooth wireless mouse for laptop and desktop use.',
    imageUrl:
        'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=1000&q=80',
  ),
  Product(
    name: 'Smart Speaker',
    category: 'Smart Home',
    price: 149,
    badge: 'AI Assistant',
    description: 'Speaker for music, voice commands and smart home control.',
    imageUrl:
        'https://images.unsplash.com/photo-1543512214-318c7553f230?auto=format&fit=crop&w=1000&q=80',
  ),
];

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int selectedIndex = 0;
  final List<Product> cartItems = [];

  void openPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void addToCart(Product product) {
    setState(() {
      cartItems.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: const Color(0xFF24664B),
      ),
    );
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  double get subtotal {
    double sum = 0;
    for (final product in cartItems) {
      sum += product.price;
    }
    return sum;
  }

  double get delivery => cartItems.isEmpty ? 0 : 10;

  double get total => subtotal + delivery;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    final pages = [
      HomePage(
        onProducts: () => openPage(1),
        onCart: () => openPage(2),
        onPayment: () => openPage(3),
        onAccount: () => openPage(4),
        onAddToCart: addToCart,
      ),
      ProductsPage(onAddToCart: addToCart),
      CartPage(
        cartItems: cartItems,
        subtotal: subtotal,
        delivery: delivery,
        total: total,
        onRemove: removeFromCart,
        onProducts: () => openPage(1),
        onPayment: () => openPage(3),
      ),
      PaymentPage(
        cartItems: cartItems,
        subtotal: subtotal,
        delivery: delivery,
        total: total,
        onProducts: () => openPage(1),
      ),
      const AccountPage(),
    ];

    final titles = [
      'Home',
      'Products',
      'Cart',
      'Payment',
      'Account',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123F30),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () => openPage(2),
                icon: const Icon(Icons.shopping_cart_rounded),
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            DesktopMenu(
              selectedIndex: selectedIndex,
              onSelect: openPage,
            ),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: selectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF24664B),
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              onTap: openPage,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_rounded),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_rounded),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.payment_rounded),
                  label: 'Payment',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Account',
                ),
              ],
            ),
    );
  }
}

class DesktopMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const DesktopMenu({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      color: const Color(0xFF123F30),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.devices_rounded,
              color: Colors.white,
              size: 66,
            ),
            const SizedBox(height: 12),
            const Text(
              'TECH STORE PRO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            menuItem(Icons.home_rounded, 'Home', 0),
            menuItem(Icons.shopping_bag_rounded, 'Products', 1),
            menuItem(Icons.shopping_cart_rounded, 'Cart', 2),
            menuItem(Icons.payment_rounded, 'Payment', 3),
            menuItem(Icons.person_rounded, 'Account', 4),
          ],
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title, int index) {
    final bool active = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: active ? const Color(0xFF24664B) : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: active ? const Color(0xFF24664B) : Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        onTap: () => onSelect(index),
      ),
    );
  }
}

class ResponsivePage extends StatelessWidget {
  final Widget child;

  const ResponsivePage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          isPhone ? 16 : 34,
          isPhone ? 18 : 30,
          isPhone ? 16 : 34,
          isPhone ? 96 : 34,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: child,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onProducts;
  final VoidCallback onCart;
  final VoidCallback onPayment;
  final VoidCallback onAccount;
  final Function(Product) onAddToCart;

  const HomePage({
    super.key,
    required this.onProducts,
    required this.onCart,
    required this.onPayment,
    required this.onAccount,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroSection(
            onProducts: onProducts,
            onAccount: onAccount,
          ),
          const SizedBox(height: 34),
          SectionTitle(
            title: 'Latest Technology Collection',
            subtitle:
                'Explore new laptops, phones, smart devices, VR, drones and accessories.',
            onPressed: onProducts,
          ),
          const SizedBox(height: 24),
          ProductWrap(
            products: allProducts.take(8).toList(),
            onAddToCart: onAddToCart,
          ),
          const SizedBox(height: 36),
          QuickActions(
            onProducts: onProducts,
            onCart: onCart,
            onPayment: onPayment,
            onAccount: onAccount,
          ),
          const SizedBox(height: 36),
          const ServicesPreview(),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  final VoidCallback onProducts;
  final VoidCallback onAccount;

  const HeroSection({
    super.key,
    required this.onProducts,
    required this.onAccount,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.all(isPhone ? 24 : 42),
      decoration: BoxDecoration(
        color: const Color(0xFF123F30),
        borderRadius: BorderRadius.circular(32),
      ),
      child: isPhone
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: heroContent(context, isPhone),
            )
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: heroText(context, isPhone),
                  ),
                ),
                const SizedBox(width: 34),
                Expanded(
                  child: NetworkPhoto(
                    imageUrl:
                        'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1400&q=80',
                    height: 360,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> heroContent(BuildContext context, bool isPhone) {
    return [
      ...heroText(context, isPhone),
      const SizedBox(height: 30),
      NetworkPhoto(
        imageUrl:
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1400&q=80',
        height: 220,
        borderRadius: BorderRadius.circular(26),
      ),
    ];
  }

  List<Widget> heroText(BuildContext context, bool isPhone) {
    return [
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: isPhone ? 14 : 20,
          vertical: isPhone ? 9 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          'TECH STORE PRO',
          style: TextStyle(
            color: Colors.white,
            fontSize: isPhone ? 13 : 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.7,
            height: 1.4,
          ),
        ),
      ),
      const SizedBox(height: 26),
      Text(
        'Smart devices\nin one place',
        style: TextStyle(
          color: Colors.white,
          fontSize: isPhone ? 35 : 58,
          fontWeight: FontWeight.w900,
          height: 1.16,
        ),
      ),
      const SizedBox(height: 22),
      Text(
        'Shop laptops, phones, watches, VR headsets, drones, cameras and accessories. Add products to cart and continue to secure payment.',
        style: TextStyle(
          color: Colors.white.withOpacity(0.88),
          fontSize: isPhone ? 16 : 20,
          height: 1.75,
        ),
      ),
      const SizedBox(height: 30),
      Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onProducts,
              icon: const Icon(Icons.shopping_bag_rounded),
              label: const Text('Shop Now'),
              style: greenButton(),
            ),
          ),
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: onAccount,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Create Account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }
}

class ProductsPage extends StatelessWidget {
  final Function(Product) onAddToCart;

  const ProductsPage({
    super.key,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Products',
            subtitle: 'Choose your favorite smart device and add it to cart.',
            icon: Icons.shopping_bag_rounded,
          ),
          const SizedBox(height: 30),
          ProductWrap(
            products: allProducts,
            onAddToCart: onAddToCart,
          ),
        ],
      ),
    );
  }
}

class ProductWrap extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onAddToCart;

  const ProductWrap({
    super.key,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;
return LayoutBuilder(
      builder: (context, constraints) {
        final double gap = 24;
        final double width = constraints.maxWidth;

        double cardWidth;
        if (isPhone) {
          cardWidth = width;
        } else if (width < 950) {
          cardWidth = (width - gap) / 2;
        } else {
          cardWidth = (width - gap * 2) / 3;
        }

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: products.map((product) {
            return SizedBox(
              width: cardWidth,
              child: ProductCard(
                product: product,
                onAddToCart: () => onAddToCart(product),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;

    return Container(
      decoration: whiteCard(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NetworkPhoto(
            imageUrl: product.imageUrl,
            height: isPhone ? 235 : 210,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              isPhone ? 22 : 20,
              isPhone ? 24 : 20,
              isPhone ? 22 : 20,
              isPhone ? 26 : 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    SmallBadge(text: product.category.toUpperCase()),
                    SmallBadge(text: product.badge),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: isPhone ? 26 : 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111816),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.description,
                  style: const TextStyle(
                    color: Color(0xFF68756F),
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  '${product.price.toStringAsFixed(0)}€',
                  style: TextStyle(
                    color: const Color(0xFF24664B),
                    fontSize: isPhone ? 27 : 25,
                    fontWeight: FontWeight.w900,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: const Text('Add to Cart'),
                    style: greenButton(),
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

class CartPage extends StatelessWidget {
  final List<Product> cartItems;
  final double subtotal;
  final double delivery;
  final double total;
  final Function(int) onRemove;
  final VoidCallback onProducts;
  final VoidCallback onPayment;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.delivery,
    required this.total,
    required this.onRemove,
    required this.onProducts,
    required this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Cart',
            subtitle: 'Review your selected products before payment.',
            icon: Icons.shopping_cart_rounded,
          ),
          const SizedBox(height: 30),
          if (cartItems.isEmpty)
            EmptyCard(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Go to products and add something first.',
              buttonText: 'View Products',
              onPressed: onProducts,
            )
          else ...[
            CartList(
              cartItems: cartItems,
              onRemove: onRemove,
            ),
            const SizedBox(height: 24),
            SummaryCard(
              subtotal: subtotal,
              delivery: delivery,
              total: total,
              onPayment: onPayment,
            ),
          ],
        ],
      ),
    );
  }
}

class CartList extends StatelessWidget {
  final List<Product> cartItems;
  final Function(int) onRemove;

  const CartList({
    super.key,
    required this.cartItems,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(cartItems.length, (index) {
        final item = cartItems[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: whiteCard(),
          child: Row(
            children: [
              NetworkPhoto(
                imageUrl: item.imageUrl,
                width: 96,
                height: 96,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.category,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.price.toStringAsFixed(0)}€',
                      style: const TextStyle(
                        color: Color(0xFF24664B),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onRemove(index),
                icon: const Icon(Icons.delete_outline_rounded),
                color: Colors.red,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final List<Product> cartItems;
  final double subtotal;
  final double delivery;
  final double total;
  final VoidCallback onProducts;

  const PaymentPage({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.delivery,
    required this.total,
    required this.onProducts,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Payment',
            subtitle: 'Complete your order with secure payment.',
            icon: Icons.payment_rounded,
          ),
          const SizedBox(height: 30),
          if (cartItems.isEmpty)
            EmptyCard(
              icon: Icons.shopping_bag_outlined,
              title: 'No products to pay',
              subtitle: 'Please add products to cart before payment.',
              buttonText: 'Go to Products',
              onPressed: onProducts,
            )
          else ...[
            PaymentForm(total: total),
            const SizedBox(height: 24),
            SummaryCard(
              subtotal: subtotal,
              delivery: delivery,
              total: total,
              onPayment: () {},
            ),
          ],
        ],
      ),
    );
  }
}

class PaymentForm extends StatelessWidget {
  final double total;

  const PaymentForm({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: whiteCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          const AppTextField(
            hint: 'Full name',
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 22),
          const AppTextField(
            hint: 'Address',
            icon: Icons.location_on_rounded,
          ),
          const SizedBox(height: 22),
          const AppTextField(
            hint: 'Card number',
            icon: Icons.credit_card_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 22),
          const AppTextField(
            hint: 'CVV',
            icon: Icons.lock_rounded,
            obscureText: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check_circle_rounded),
              label: Text('Pay ${total.toStringAsFixed(0)}€'),
              style: greenButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool createAccount = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: whiteCard(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  createAccount
                      ? Icons.person_add_alt_1_rounded
                      : Icons.lock_rounded,
                  size: 76,
                  color: const Color(0xFF24664B),
                ),
                const SizedBox(height: 26),
                Text(
                  createAccount ? 'Create Account' : 'Login',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  createAccount
                      ? 'Register to continue shopping with Tech Store Pro.'
                      : 'Login with email, username or phone number.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 34),
                if (createAccount) ...[
                  const AppTextField(
                    hint: 'Full name',
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(height: 22),
                  const AppTextField(
                    hint: 'Phone number',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 22),
                ],
                const AppTextField(
                  hint: 'Email or username',
                  icon: Icons.email_rounded,
                ),
                const SizedBox(height: 22),
                AppTextField(
                  hint: 'Password',
                  icon: Icons.lock_rounded,
                  obscureText: hidePassword,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: greenButton(),
                    child: Text(
                      createAccount ? 'Create Account' : 'Login',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        createAccount = !createAccount;
                      });
                    },
                    child: Text(
                      createAccount
                          ? 'Already have an account? Login'
                          : 'Create Account',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  final VoidCallback onProducts;
  final VoidCallback onCart;
  final VoidCallback onPayment;
  final VoidCallback onAccount;

  const QuickActions({
    super.key,
    required this.onProducts,
    required this.onCart,
    required this.onPayment,
    required this.onAccount,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;

    final actions = [
      ['Products', Icons.shopping_bag_rounded, onProducts],
      ['Cart', Icons.shopping_cart_rounded, onCart],
      ['Payment', Icons.payment_rounded, onPayment],
      ['Account', Icons.person_rounded, onAccount],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const double gap = 16;
        final double width = isPhone
            ? (constraints.maxWidth - gap) / 2
            : (constraints.maxWidth - gap * 3) / 4;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: actions.map((item) {
            return SizedBox(
              width: width,
              child: InkWell(
                onTap: item[2] as VoidCallback,
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: whiteCard(),
                  child: Column(
                    children: [
                      Icon(
                        item[1] as IconData,
                        color: const Color(0xFF24664B),
                        size: 40,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        item[0] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class ServicesPreview extends StatelessWidget {
  const ServicesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;

    final services = [
      ['Fast Delivery', Icons.local_shipping_rounded],
      ['Device Repair', Icons.build_rounded],
      ['Secure Payment', Icons.security_rounded],
      ['Support 24/7', Icons.support_agent_rounded],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const double gap = 16;
        final double width = isPhone
            ? constraints.maxWidth
            : (constraints.maxWidth - gap * 3) / 4;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: services.map((service) {
            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: whiteCard(),
                child: Row(
                  children: [
                    Icon(
                      service[1] as IconData,
                      color: const Color(0xFF24664B),
                      size: 38,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        service[0] as String,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isPhone ? 28 : 34,
            fontWeight: FontWeight.w900,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: onPressed,
          child: const Text('View all products'),
        ),
      ],
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.all(isPhone ? 26 : 32),
      decoration: BoxDecoration(
        color: const Color(0xFF123F30),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: isPhone ? 46 : 62,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isPhone ? 32 : 46,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isPhone ? 16 : 19,
                    height: 1.65,
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

class SummaryCard extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double total;
  final VoidCallback onPayment;

  const SummaryCard({
    super.key,
    required this.subtotal,
    required this.delivery,
    required this.total,
    required this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: whiteCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),
          SummaryRow(label: 'Subtotal', value: '${subtotal.toStringAsFixed(0)}€'),
          SummaryRow(label: 'Delivery', value: '${delivery.toStringAsFixed(0)}€'),
          const Divider(height: 38),
          SummaryRow(
            label: 'Total',
            value: '${total.toStringAsFixed(0)}€',
            isTotal: true,
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 60,
            child: ElevatedButton.icon(
              onPressed: onPayment,
              icon: const Icon(Icons.payment_rounded),
              label: const Text('Continue to Payment'),
              style: greenButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 20 : 17,
                fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
                height: 1.6,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? const Color(0xFF24664B) : Colors.black,
              fontSize: isTotal ? 22 : 17,
              fontWeight: FontWeight.w900,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const EmptyCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: whiteCard(),
      child: Column(
        children: [
          Icon(
            icon,
            size: 88,
            color: const Color(0xFF24664B),
          ),
          const SizedBox(height: 26),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              height: 1.85,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 58,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: greenButton(),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 16,
        height: 1.55,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 16,
          height: 1.55,
        ),
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(
            color: Color(0xFFDCE7E1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(
            color: Color(0xFF24664B),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class SmallBadge extends StatelessWidget {
  final String text;

  const SmallBadge({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3EF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF24664B),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.7,
          height: 1.3,
        ),
      ),
    );
  }
}

class NetworkPhoto extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const NetworkPhoto({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final photo = Image.network(
      imageUrl,
      height: height,
      width: width ?? double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          height: height,
          width: width ?? double.infinity,
          color: const Color(0xFFEAF3EF),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF24664B),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width ?? double.infinity,
          color: const Color(0xFFEAF3EF),
          child: const Center(
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 58,
              color: Color(0xFF24664B),
            ),
          ),
        );
      },
    );

    if (borderRadius == null) {
      return photo;
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: photo,
    );
  }
}

ButtonStyle greenButton() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF24664B),
    foregroundColor: Colors.white,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w900,
      height: 1.4,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
    ),
  );
}

BoxDecoration whiteCard() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(32),
    border: Border.all(
      color: const Color(0xFFDCE7E1),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 20,
        offset: const Offset(0, 9),
      ),
    ],
  );
}

