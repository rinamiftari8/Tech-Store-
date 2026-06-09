import 'package:flutter/material.dart';

import 'package:tech_store/modules/dashboard/views/tasks_calendar_page.dart';
 
import 'package:tech_store/data/product_data.dart';
import 'package:tech_store/modules/orders/models/order.dart';
import 'package:tech_store/modules/products/models/product.dart';
import 'package:tech_store/core/services/api_service.dart';
import 'package:tech_store/core/services/auth_service.dart';
import 'package:tech_store/utils/app_styles.dart';
import 'package:tech_store/widgets/common_widgets.dart';
 
class DashboardPage extends StatefulWidget {
  final VoidCallback onLogout;
 
  const DashboardPage({
    super.key,
    required this.onLogout,
  });
 
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}
 
class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;
  Product? selectedProduct;
 
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();

  String profileFullName = 'Rina';
  String profileUsername = 'rinamiftari';
  String profileEmail = 'rinamiftari88@gmail.com';
 
  final List<Product> cart = [];
  final Set<Product> favorites = <Product>{};
  final List<Order> orders = [];
  final List<String> notifications = <String>[
    'Welcome to Tech Store Pro.',
  ];
 
  String searchQuery = '';
  String selectedCategory = 'All';

  String selectedService = 'Laptop Repair';

  final List<String> services = [
    'Laptop Repair',
    'Phone Repair',
    'Software Installation',
    'Data Recovery',
    'Device Cleaning',
    'Smart Watch Setup',
    'Gaming PC Setup',
  ];

  final List<String> serviceBookings = [];

  final TextEditingController bookingNameController = TextEditingController();
  final TextEditingController bookingPhoneController = TextEditingController();
  final TextEditingController bookingDateController = TextEditingController();
 
  late final Future<String> apiTipFuture;
 
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    apiTipFuture = apiService.fetchApiTip();
  }
 
  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    cardController.dispose();
    cvvController.dispose();
    super.dispose();
  }
 
  void openPage(int index) {
    setState(() {
      selectedIndex = index;
      selectedProduct = null;
    });
  }
 
  void openProductDetails(Product product) {
    setState(() {
      selectedProduct = product;
    });
  }
 
  void showAppNotification(String message) {
    setState(() {
      notifications.insert(0, message);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF24664B),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
 
    showAppNotification('${product.name} added to cart');
  }
 
  void removeFromCart(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }
 
  void toggleFavorite(Product product) {
    setState(() {
      if (favorites.contains(product)) {
        favorites.remove(product);
      } else {
        favorites.add(product);
      }
    });
  }
 
  double get subtotal {
    double sum = 0;
 
    for (final item in cart) {
      sum += item.price;
    }
 
    return sum;
  }
 
  double get delivery {
    if (cart.isEmpty) {
      return 0;
    }
 
    return 10;
  }
 
  double get total {
    return subtotal + delivery;
  }
 
  List<Product> get filteredProducts {
    final String query = searchQuery.trim().toLowerCase();
 
    return products.where((product) {
      final bool matchesCategory = selectedCategory == 'All' ||
          product.category.toLowerCase() == selectedCategory.toLowerCase();
 
      final bool matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.badge.toLowerCase().contains(query);
 
      return matchesCategory && matchesSearch;
    }).toList();
  }
 
  void bookService() {
    if (bookingNameController.text.trim().isEmpty ||
        bookingPhoneController.text.trim().isEmpty ||
        bookingDateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all service booking fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String booking =
        '$selectedService for ${bookingNameController.text.trim()} - ${bookingDateController.text.trim()}';

    setState(() {
      serviceBookings.insert(0, booking);
      bookingNameController.clear();
      bookingPhoneController.clear();
      bookingDateController.clear();
    });

    showAppNotification('Service booking created: $selectedService.');
  }
  void completePayment() {
    if (cart.isEmpty) {
      return;
    }
 
    if (fullNameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        cardController.text.trim().isEmpty ||
        cvvController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all payment fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
 
    final int id = DateTime.now().millisecondsSinceEpoch;
    final String date = DateTime.now().toString().substring(0, 16);
    final double orderTotal = total;
 
    setState(() {
      orders.insert(
        0,
        Order(
          id: id,
          items: List<Product>.from(cart),
          total: orderTotal,
          date: date,
        ),
      );
 
      cart.clear();
      fullNameController.clear();
      addressController.clear();
      cardController.clear();
      cvvController.clear();
      selectedProduct = null;
      selectedIndex = 4;
    });
 
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Text(
            'Your order of ${orderTotal.toStringAsFixed(0)}\u20AC was completed successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
 
    showAppNotification('Order completed successfully.');
  }
 
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
 
    final String title = selectedProduct == null
        ? [
            'Dashboard',
            'Products',
            'Favorites',
            'Cart',
            'Orders',
            'Payment',
            'Notifications',
            'Analytics',
            'Services',
            'Account',
            'Tasks & Calendar',
          ][selectedIndex]
        : 'Product Details';
 
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123F30),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () => openPage(3),
                icon: const Icon(Icons.shopping_cart_rounded),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      cart.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),          Stack(
            children: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: () => openPage(6),
                icon: const Icon(Icons.notifications_rounded),
              ),
              if (notifications.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.orange,
                    child: Text(
                      notifications.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop) sideMenu(),
          Expanded(
            child: selectedProduct == null
                ? currentPage()
                : productDetailsPage(selectedProduct!),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: bottomIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF24664B),
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              onTap: (index) {
                if (index == 0) openPage(0);
                if (index == 1) openPage(1);
                if (index == 2) openPage(2);
                if (index == 3) openPage(3);
                if (index == 4) openPage(9);
              },
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
                  icon: Icon(Icons.favorite_rounded),
                  label: 'Fav',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_rounded),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Account',
                ),
              ],
            ),
    );
  }
 
  int get bottomIndex {
    if (selectedIndex == 0) return 0;
    if (selectedIndex == 1) return 1;
    if (selectedIndex == 2) return 2;
    if (selectedIndex == 3) return 3;
 
    return 4;
  }
 
  Widget currentPage() {
    if (selectedIndex == 0) return homePage();
    if (selectedIndex == 1) return productsPage();
    if (selectedIndex == 2) return favoritesPage();
    if (selectedIndex == 3) return cartPage();
    if (selectedIndex == 4) return ordersPage();
    if (selectedIndex == 5) return paymentPage();
    if (selectedIndex == 6) return notificationsPage();
    if (selectedIndex == 7) return analyticsPage();
    if (selectedIndex == 8) return serviceBookingPage();
    if (selectedIndex == 10) return const TasksCalendarPage();

    return accountPage();
  }
  Widget sideMenu() {
    return Container(
      width: 235,
      color: const Color(0xFF123F30),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
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
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              menuItem(Icons.home_rounded, 'Home', 0),
              menuItem(Icons.shopping_bag_rounded, 'Products', 1),
              menuItem(Icons.favorite_rounded, 'Favorites', 2),
              menuItem(Icons.shopping_cart_rounded, 'Cart', 3),
              menuItem(Icons.receipt_long_rounded, 'Orders', 4),
              menuItem(Icons.payment_rounded, 'Payment', 5),
              menuItem(Icons.notifications_rounded, 'Notifications', 6),
              menuItem(Icons.analytics_rounded, 'Analytics', 7),
              menuItem(Icons.build_circle_rounded, 'Services', 8),
              menuItem(Icons.event_note_rounded, 'Tasks & Calendar', 10),
              menuItem(Icons.person_rounded, 'Account', 9),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  Widget menuItem(IconData icon, String title, int index) {
    final bool active = selectedIndex == index && selectedProduct == null;
 
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
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
        onTap: () => openPage(index),
      ),
    );
  }
 
  Widget pageWrapper(Widget child) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;
 
    return Container(
      decoration: appGradient(),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            isPhone ? 16 : 34,
            isPhone ? 18 : 30,
            isPhone ? 16 : 34,
            isPhone ? 96 : 34,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
 
  Widget homePage() {
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heroCard(),
          const SizedBox(height: 22),
          promoCards(),
          const SizedBox(height: 24),
          apiCard(),
          const SizedBox(height: 26),
          searchBox(),
          const SizedBox(height: 26),
          sectionTitle(
            title: 'Latest Technology Collection',
            subtitle:
                'Explore laptops, phones, watches, audio, VR, drones, cameras and accessories.',
            buttonText: 'View all products',
            onPressed: () => openPage(1),
          ),
          const SizedBox(height: 24),
          productWrap(products.take(6).toList()),
          const SizedBox(height: 34),
          aestheticGallery(),
          const SizedBox(height: 34),
          quickActions(),
          const SizedBox(height: 34),
          servicesPreview(),
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
 
  Widget productsPage() {
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Products',
            subtitle: 'Search and choose your favorite smart device.',
            icon: Icons.shopping_bag_rounded,
          ),
          const SizedBox(height: 24),
          searchBox(),
          const SizedBox(height: 18),
          categoryFilters(),
          const SizedBox(height: 24),
          if (filteredProducts.isEmpty)
            emptyCard(
              icon: Icons.search_off_rounded,
              title: 'No products found',
              subtitle: 'Try another product name or category.',
              buttonText: 'Clear Search',
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  selectedCategory = 'All';
                });
              },
            )
          else
            productWrap(filteredProducts),
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
 
  Widget favoritesPage() {
    final List<Product> favoriteList = favorites.toList();
 
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Favorites',
            subtitle: 'Products you saved for later.',
            icon: Icons.favorite_rounded,
          ),
          const SizedBox(height: 30),
          if (favoriteList.isEmpty)
            emptyCard(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              subtitle: 'Tap the heart icon on a product to save it here.',
              buttonText: 'View Products',
              onPressed: () => openPage(1),
            )
          else
            productWrap(favoriteList),
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
 
  Widget cartPage() {
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Cart',
            subtitle: 'Review your selected products before payment.',
            icon: Icons.shopping_cart_rounded,
          ),
          const SizedBox(height: 30),
          if (cart.isEmpty)
            emptyCard(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Go to products and add something first.',
              buttonText: 'View Products',
              onPressed: () => openPage(1),
            )
          else ...[
            ...List.generate(
              cart.length,
              (index) {
                return cartItem(cart[index], index);
              },
            ),
            const SizedBox(height: 20),
            summaryCard(),
          ],
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
 
  Widget ordersPage() {
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Order History',
            subtitle: 'Completed orders will be shown here.',
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 30),
          if (orders.isEmpty)
            emptyCard(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              subtitle: 'Complete a payment and your order will appear here.',
              buttonText: 'View Products',
              onPressed: () => openPage(1),
            )
          else
            Column(
              children: orders.map(orderCard).toList(),
            ),
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
 
  Widget paymentPage() {
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Payment',
            subtitle: 'Complete your order with secure payment.',
            icon: Icons.payment_rounded,
          ),
          const SizedBox(height: 30),
          if (cart.isEmpty)
            emptyCard(
              icon: Icons.shopping_bag_outlined,
              title: 'No products to pay',
              subtitle: 'Please add products to cart before payment.',
              buttonText: 'Go to Products',
              onPressed: () => openPage(1),
            )
          else ...[
            paymentForm(),
            const SizedBox(height: 24),
            summaryCard(),
          ],
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
 
  Widget analyticsPage() {
    double revenue = 0;

    for (final order in orders) {
      revenue += order.total;
    }

    final Map<String, int> categoryCounts = <String, int>{};

    for (final product in products) {
      categoryCounts[product.category] =
          (categoryCounts[product.category] ?? 0) + 1;
    }

    Widget analyticsCard({
      required IconData icon,
      required String title,
      required String value,
      required String subtitle,
    }) {
      return Container(
        padding: const EdgeInsets.all(22),
        decoration: whiteCard(),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFDDEEE5),
              child: Icon(
                icon,
                color: const Color(0xFF24664B),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF123F30),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF68756F),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget categoryRow(String category, int count) {
      final double percent = products.isEmpty ? 0 : count / products.length;

      return Container(
        margin: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '$count products',
                  style: const TextStyle(
                    color: Color(0xFF24664B),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 12,
                backgroundColor: const Color(0xFFEAF3EF),
                color: const Color(0xFF24664B),
              ),
            ),
          ],
        ),
      );
    }

    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Analytics Dashboard',
            subtitle:
                'Overview of products, cart activity, favorites, orders and revenue.',
            icon: Icons.analytics_rounded,
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isPhone = MediaQuery.of(context).size.width < 700;
              const double gap = 16;

              final double width = isPhone
                  ? constraints.maxWidth
                  : (constraints.maxWidth - gap) / 2;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  SizedBox(
                    width: width,
                    child: analyticsCard(
                      icon: Icons.inventory_2_rounded,
                      title: 'Total Products',
                      value: products.length.toString(),
                      subtitle: 'Products available in the store.',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: analyticsCard(
                      icon: Icons.shopping_cart_rounded,
                      title: 'Cart Items',
                      value: cart.length.toString(),
                      subtitle: 'Products currently added to cart.',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: analyticsCard(
                      icon: Icons.favorite_rounded,
                      title: 'Favorites',
                      value: favorites.length.toString(),
                      subtitle: 'Products saved by the user.',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: analyticsCard(
                      icon: Icons.receipt_long_rounded,
                      title: 'Completed Orders',
                      value: orders.length.toString(),
                      subtitle: 'Orders completed through payment.',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: analyticsCard(
                      icon: Icons.euro_rounded,
                      title: 'Total Revenue',
                      value: '${revenue.toStringAsFixed(0)}\u20AC',
                      subtitle: 'Revenue from completed orders.',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: analyticsCard(
                      icon: Icons.category_rounded,
                      title: 'Categories',
                      value: categoryCounts.length.toString(),
                      subtitle: 'Technology categories in the catalog.',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(26),
            decoration: whiteCard(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category Overview',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF123F30),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Simple data visualization showing how products are distributed by category.',
                  style: TextStyle(
                    color: Color(0xFF68756F),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                ...categoryCounts.entries.map((entry) {
                  return categoryRow(entry.key, entry.value);
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
  Widget notificationsPage() {
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Notifications',
            subtitle: 'Important alerts and updates from your store activity.',
            icon: Icons.notifications_rounded,
          ),
          const SizedBox(height: 30),
          if (notifications.isEmpty)
            emptyCard(
              icon: Icons.notifications_none_rounded,
              title: 'No notifications',
              subtitle: 'Your notifications will appear here.',
              buttonText: 'Go to Products',
              onPressed: () => openPage(1),
            )
          else ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    notifications.clear();
                  });
                },
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Clear All'),
              ),
            ),
            const SizedBox(height: 12),
            ...notifications.map((message) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: whiteCard(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFDDEEE5),
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: Color(0xFF24664B),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }

  Widget serviceBookingPage() {
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Service Booking',
            subtitle:
                'Book repair, setup, installation or recovery services for your devices.',
            icon: Icons.build_circle_rounded,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(26),
            decoration: whiteCard(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Choose Service',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF123F30),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: services.map((service) {
                    final bool active = selectedService == service;

                    return ChoiceChip(
                      label: Text(service),
                      selected: active,
                      selectedColor: const Color(0xFF24664B),
                      labelStyle: TextStyle(
                        color: active ? Colors.white : const Color(0xFF24664B),
                        fontWeight: FontWeight.w800,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedService = service;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 26),
                appField(
                  controller: bookingNameController,
                  hint: 'Full name',
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 18),
                appField(
                  controller: bookingPhoneController,
                  hint: 'Phone number',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 18),
                appField(
                  controller: bookingDateController,
                  hint: 'Preferred date, e.g. 05/06/2026',
                  icon: Icons.calendar_month_rounded,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: bookService,
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text('Book Service'),
                    style: greenButton(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(26),
            decoration: whiteCard(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Service Bookings',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF123F30),
                  ),
                ),
                const SizedBox(height: 18),
                if (serviceBookings.isEmpty)
                  const Text(
                    'No service bookings yet.',
                    style: TextStyle(
                      color: Color(0xFF68756F),
                      fontSize: 16,
                      height: 1.6,
                    ),
                  )
                else
                  ...serviceBookings.map((booking) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3EF),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFFDCE7E1),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.build_rounded,
                            color: Color(0xFF24664B),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              booking,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                            ),
                          ),
                          greenPill('Booked'),
                        ],
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
  Widget accountPage() {
    final String fullName = profileFullName;

    final String username = profileUsername;

    final String email = profileEmail;

    double revenue = 0;

    for (final order in orders) {
      revenue += order.total;
    }

    Widget profileInfoRow({
      required IconData icon,
      required String title,
      required String value,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF3EF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFDCE7E1),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                icon,
                color: const Color(0xFF24664B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF68756F),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF123F30),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget profileStat({
      required IconData icon,
      required String value,
      required String title,
    }) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: whiteCard(),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF24664B),
              size: 34,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF123F30),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF68756F),
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageHeader(
            title: 'Account Profile',
            subtitle:
                'Manage your profile information and view your store activity.',
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 30),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 760,
              ),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: whiteCard(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CircleAvatar(
                      radius: 52,
                      backgroundColor: Color(0xFFDDEEE5),
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF24664B),
                        size: 62,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      fullName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF123F30),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: greenPill('Verified Account'),
                    ),
                    const SizedBox(height: 28),
                    profileInfoRow(
                      icon: Icons.person_rounded,
                      title: 'Full Name',
                      value: fullName,
                    ),
                    profileInfoRow(
                      icon: Icons.alternate_email_rounded,
                      title: 'Username',
                      value: username,
                    ),
                    profileInfoRow(
                      icon: Icons.email_rounded,
                      title: 'Email',
                      value: email,
                    ),
                    profileInfoRow(
                      icon: Icons.verified_user_rounded,
                      title: 'Account Status',
                      value: 'Active and verified',
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isPhone =
                            MediaQuery.of(context).size.width < 700;

                        const double gap = 14;

                        final double width = isPhone
                            ? (constraints.maxWidth - gap) / 2
                            : (constraints.maxWidth - gap * 3) / 4;

                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            SizedBox(
                              width: width,
                              child: profileStat(
                                icon: Icons.shopping_cart_rounded,
                                value: cart.length.toString(),
                                title: 'Cart Items',
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: profileStat(
                                icon: Icons.favorite_rounded,
                                value: favorites.length.toString(),
                                title: 'Favorites',
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: profileStat(
                                icon: Icons.receipt_long_rounded,
                                value: orders.length.toString(),
                                title: 'Orders',
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: profileStat(
                                icon: Icons.euro_rounded,
                                value: revenue.toStringAsFixed(0),
                                title: 'Revenue',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 58,
                      child: OutlinedButton.icon(
                        onPressed: () => openPage(4),
                        icon: const Icon(Icons.receipt_long_rounded),
                        label: const Text('View Order History'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 58,
                      child: OutlinedButton.icon(
                        onPressed: () => openPage(6),
                        icon: const Icon(Icons.notifications_rounded),
                        label: const Text('View Notifications'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: widget.onLogout,
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
  Widget productDetailsPage(Product product) {
    final bool isFav = favorites.contains(product);
 
    return pageWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  selectedProduct = null;
                });
              },
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: whiteCard(),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    appImage(
                      product.imageUrl,
                      height: 285,
                    ),
                    Positioned(
                      top: 18,
                      left: 18,
                      child: greenPill(product.badge),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () => toggleFavorite(product),
                          icon: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFav ? Colors.red : const Color(0xFF24664B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      categoryPill(
                        product.category.toUpperCase(),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.description,
                        style: const TextStyle(
                          color: Color(0xFF68756F),
                          fontSize: 17,
                          height: 1.75,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        '${product.price.toStringAsFixed(0)}\u20AC',
                        style: const TextStyle(
                          color: Color(0xFF24664B),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        height: 58,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => addToCart(product),
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                          label: const Text('Add to Cart'),
                          style: greenButton(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => toggleFavorite(product),
                          icon: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                          label: Text(
                            isFav
                                ? 'Remove from Favorites'
                                : 'Add to Favorites',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 34),
          appFooter(),
        ],
      ),
    );
  }
 
  Widget heroCard() {
    final bool isPhone = MediaQuery.of(context).size.width < 700;
 
    return Container(
      padding: EdgeInsets.all(
        isPhone ? 24 : 42,
      ),
      decoration: darkHeroDecoration(),
      child: isPhone
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heroText(),
                const SizedBox(height: 28),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: appImage(
                    'https://images.unsplash.com/photo-1550009158-9ebf69173e03?auto=format&fit=crop&w=600&q=55',
                    height: 205,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: heroText(),
                ),
                const SizedBox(width: 34),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: appImage(
                      'https://images.unsplash.com/photo-1550009158-9ebf69173e03?auto=format&fit=crop&w=700&q=55',
                      height: 315,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
 
  Widget heroText() {
    final bool isPhone = MediaQuery.of(context).size.width < 700;
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelChip('TECH STORE PRO'),
        const SizedBox(height: 26),
        Text(
          'New Tech Arrivals\nFor Your Setup',
          style: TextStyle(
            color: Colors.white,
            fontSize: isPhone ? 34 : 56,
            fontWeight: FontWeight.w900,
            height: 1.16,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Upgrade your desk, school work, gaming setup and daily tech with modern devices.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.90),
            fontSize: isPhone ? 16 : 19,
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
                onPressed: () => openPage(1),
                icon: const Icon(Icons.shopping_bag_rounded),
                label: const Text('Shop Now'),
                style: greenButton(),
              ),
            ),
            SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => openPage(3),
                icon: const Icon(Icons.shopping_cart_rounded),
                label: const Text('View Cart'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
 
  Widget apiCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: softCard(),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFDDEEE5),
            child: Icon(
              Icons.api_rounded,
              color: Color(0xFF24664B),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FutureBuilder<String>(
              future: apiTipFuture,
              builder: (context, snapshot) {
                final String text = snapshot.data ?? 'Loading external API...';
 
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'External API Integration',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF123F30),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      text,
                      style: const TextStyle(
                        color: Color(0xFF68756F),
                        height: 1.5,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
 
  Widget promoCards() {
    final cards = [
      [
        'Student Discount',
        'Save more on laptops and study devices.',
        Icons.school_rounded,
      ],
      [
        'Free Delivery',
        'Fast delivery for orders over 300\u20AC.',
        Icons.local_shipping_rounded,
      ],
      [
        'Premium Support',
        'Support for setup, repair and devices.',
        Icons.support_agent_rounded,
      ],
    ];
 
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isPhone = MediaQuery.of(context).size.width < 700;
        const double gap = 16;
 
        final double width = isPhone
            ? constraints.maxWidth
            : (constraints.maxWidth - gap * 2) / 3;
 
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards.map((item) {
            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: softCard(),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFEAF3EF),
                      child: Icon(
                        item[2] as IconData,
                        color: const Color(0xFF24664B),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item[0] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item[1] as String,
                            style: const TextStyle(
                              color: Color(0xFF68756F),
                              height: 1.45,
                            ),
                          ),
                        ],
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
 
  Widget aestheticGallery() {
    final gallery = [
      'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=600&q=55',
      'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=600&q=55',
      'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=600&q=55',
    ];
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(
          title: 'Aesthetic Tech Setups',
          subtitle: 'Clean desk inspiration for study, gaming and work.',
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isPhone = MediaQuery.of(context).size.width < 700;
            const double gap = 16;
 
            final double width = isPhone
                ? constraints.maxWidth
                : (constraints.maxWidth - gap * 2) / 3;
 
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: gallery.map((url) {
                return SizedBox(
                  width: width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: appImage(
                      url,
                      height: isPhone ? 165 : 195,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
 
  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: whiteCard(),
      child: TextField(
        onTap: () {
          if (selectedIndex == 0) {
            openPage(1);
          }
        },
        onChanged: (value) {
          setState(() {
            searchQuery = value;
            selectedProduct = null;
            selectedIndex = 1;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search products, e.g. laptop, phone, camera...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: searchQuery.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close_rounded),
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
      ),
    );
  }
 
  Widget categoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: categories.map((category) {
          final bool active = selectedCategory == category;
 
          return Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: ChoiceChip(
              label: Text(category),
              selected: active,
              selectedColor: const Color(0xFF24664B),
              labelStyle: TextStyle(
                color: active ? Colors.white : const Color(0xFF24664B),
                fontWeight: FontWeight.w800,
              ),
              onSelected: (_) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
 
  Widget productWrap(List<Product> list) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;
 
    return LayoutBuilder(
      builder: (context, constraints) {
        const double gap = 22;
        final double availableWidth = constraints.maxWidth;
        double cardWidth;
 
        if (isPhone) {
          cardWidth = availableWidth;
        } else if (availableWidth < 950) {
          cardWidth = (availableWidth - gap) / 2;
        } else {
          cardWidth = (availableWidth - gap * 2) / 3;
        }
 
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: list.map((product) {
            return SizedBox(
              width: cardWidth,
              child: productCard(product),
            );
          }).toList(),
        );
      },
    );
  }
 
  Widget productCard(Product product) {
    final bool isPhone = MediaQuery.of(context).size.width < 700;
    final bool isFav = favorites.contains(product);
 
    return Container(
      decoration: whiteCard(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => openProductDetails(product),
                child: appImage(
                  product.imageUrl,
                  height: isPhone ? 185 : 170,
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: greenPill(product.badge),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () => toggleFavorite(product),
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.red : const Color(0xFF24664B),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              22,
              22,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                categoryPill(
                  product.category.toUpperCase(),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => openProductDetails(product),
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  product.description,
                  style: const TextStyle(
                    color: Color(0xFF68756F),
                    fontSize: 16,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${product.price.toStringAsFixed(0)}\u20AC',
                  style: const TextStyle(
                    color: Color(0xFF24664B),
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => openProductDetails(product),
                    icon: const Icon(Icons.info_outline_rounded),
                    label: const Text('View Details'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => addToCart(product),
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
 
  Widget cartItem(Product item, int index) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      padding: const EdgeInsets.all(16),
      decoration: whiteCard(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: appImage(
              item.imageUrl,
              height: 90,
              width: 90,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.category,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.price.toStringAsFixed(0)}\u20AC',
                  style: const TextStyle(
                    color: Color(0xFF24664B),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => removeFromCart(index),
            icon: const Icon(Icons.delete_outline_rounded),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
 
  Widget orderCard(Order order) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      padding: const EdgeInsets.all(22),
      decoration: whiteCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF24664B),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Date: ${order.date}',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Products: ${order.items.map((item) => item.name).join(', ')}',
            style: const TextStyle(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Total: ${order.total.toStringAsFixed(0)}\u20AC',
            style: const TextStyle(
              color: Color(0xFF24664B),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          greenPill('Completed'),
        ],
      ),
    );
  }
 
  Widget quickActions() {
    final actions = [
      [
        'Products',
        Icons.shopping_bag_rounded,
        () => openPage(1),
      ],
      [
        'Favorites',
        Icons.favorite_rounded,
        () => openPage(2),
      ],
      [
        'Cart',
        Icons.shopping_cart_rounded,
        () => openPage(3),
      ],
      [
        'Orders',
        Icons.receipt_long_rounded,
        () => openPage(4),
      ],
      [
        'Notifications',
        Icons.notifications_rounded,
        () => openPage(6),
      ],
      [
        'Analytics',
        Icons.analytics_rounded,
        () => openPage(7),
      ],
    ];
 
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isPhone = MediaQuery.of(context).size.width < 700;
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
 
  Widget servicesPreview() {
    final services = [
      [
        'Fast Delivery',
        Icons.local_shipping_rounded,
      ],
      [
        'Device Repair',
        Icons.build_rounded,
      ],
      [
        'Secure Payment',
        Icons.security_rounded,
      ],
      [
        'Support 24/7',
        Icons.support_agent_rounded,
      ],
    ];
 
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isPhone = MediaQuery.of(context).size.width < 700;
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
 
  Widget pageHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: darkHeroDecoration(),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 46,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
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
 
  Widget sectionTitle({
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1.35,
            color: Color(0xFF123F30),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF68756F),
            fontSize: 16,
            height: 1.7,
          ),
        ),
        if (buttonText != null && onPressed != null) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ],
    );
  }
 
  Widget summaryCard() {
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
          summaryRow(
            'Subtotal',
            '${subtotal.toStringAsFixed(0)}\u20AC',
          ),
          summaryRow(
            'Delivery',
            '${delivery.toStringAsFixed(0)}\u20AC',
          ),
          const Divider(
            height: 38,
          ),
          summaryRow(
            'Total',
            '${total.toStringAsFixed(0)}\u20AC',
            isTotal: true,
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () => openPage(5),
              icon: const Icon(Icons.payment_rounded),
              label: const Text('Continue to Payment'),
              style: greenButton(),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget summaryRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 20 : 17,
                fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? const Color(0xFF24664B) : Colors.black,
              fontSize: isTotal ? 22 : 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
 
  Widget paymentForm() {
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
            ),
          ),
          const SizedBox(height: 28),
          appField(
            controller: fullNameController,
            hint: 'Full name',
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 22),
          appField(
            controller: addressController,
            hint: 'Address',
            icon: Icons.location_on_rounded,
          ),
          const SizedBox(height: 22),
          appField(
            controller: cardController,
            hint: 'Card number',
            icon: Icons.credit_card_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 22),
          appField(
            controller: cvvController,
            hint: 'CVV',
            icon: Icons.lock_rounded,
            obscureText: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 60,
            child: ElevatedButton.icon(
              onPressed: completePayment,
              icon: const Icon(Icons.check_circle_rounded),
              label: Text(
                'Pay ${total.toStringAsFixed(0)}\u20AC',
              ),
              style: greenButton(),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget emptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
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
              height: 1.8,
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
 
  Widget appFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: softCard(),
      child: const Column(
        children: [
          Text(
            'Tech Store Pro Â© 2026',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF123F30),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Fast Delivery â\u20AC¢ Secure Payment â\u20AC¢ Premium Support',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF68756F),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}















