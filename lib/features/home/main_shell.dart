import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../analytics/views/analytics_screen.dart';
import '../../auth/viewmodels/auth_view_model.dart';
import '../../auth/views/verify_email_screen.dart';
import '../../bookings/views/booking_screen.dart';
import '../../cart/viewmodels/cart_view_model.dart';
import '../../cart/views/cart_screen.dart';
import '../../notifications/viewmodels/notification_view_model.dart';
import '../../notifications/views/notifications_screen.dart';
import '../../orders/views/orders_screen.dart';
import '../../products/views/products_screen.dart';
import '../../tasks/views/tasks_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [
    ProductsScreen(),
    CartScreen(),
    BookingScreen(),
    TasksScreen(),
    AnalyticsScreen(),
    OrdersScreen(),
    NotificationsScreen(),
  ];

  static const _destinations = [
    _Destination('Store', 'Latest devices', Icons.storefront_rounded),
    _Destination('Cart', 'Selected items', Icons.shopping_bag_rounded),
    _Destination('Booking', 'Service schedule', Icons.calendar_month_rounded),
    _Destination('Tasks', 'Warranty tasks', Icons.task_alt_rounded),
    _Destination('Analytics', 'Sales insights', Icons.analytics_rounded),
    _Destination('Orders', 'Purchase history', Icons.receipt_long_rounded),
    _Destination('Notifications', 'Alerts center', Icons.notifications_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    final cartCount = context.watch<CartViewModel>().itemCount;
    final unread = context.watch<NotificationViewModel>().unreadCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 920;

        return Scaffold(
          appBar: AppBar(
            title: Text(_destinations[_index].label),
            actions: [
              _TopActionButton(
                icon: Icons.search_rounded,
                tooltip: 'Search',
                onPressed: () => setState(() => _index = 0),
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  _TopActionButton(
                    icon: Icons.notifications_none_rounded,
                    tooltip: 'Notifications',
                    onPressed: () => setState(() => _index = 6),
                  ),
                  if (unread > 0) _Badge(value: unread.toString()),
                ],
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  _TopActionButton(
                    icon: Icons.shopping_bag_outlined,
                    tooltip: 'Cart',
                    onPressed: () => setState(() => _index = 1),
                  ),
                  if (cartCount > 0) _Badge(value: cartCount.toString()),
                ],
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                offset: const Offset(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                icon: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(
                    (user?.username.isNotEmpty == true ? user!.username[0] : 'U').toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                onSelected: (value) async {
                  if (value == 'verify') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VerifyEmailScreen(),
                      ),
                    );
                  }

                  if (value == 'logout') {
                    await context.read<AuthViewModel>().logout();
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.username ?? 'User',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'verify',
                    child: Text(
                      user?.isVerified == true ? 'Verified account' : 'Verify account',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Stack(
            children: [
              const _ShellBackground(),
              Row(
                children: [
                  if (wide)
                    _PremiumSidebar(
                      selectedIndex: _index,
                      destinations: _destinations,
                      cartCount: cartCount,
                      unreadCount: unread,
                      userName: user?.username ?? 'User',
                      userEmail: user?.email ?? 'techstore@app.com',
                      verified: user?.isVerified == true,
                      onSelected: (value) => setState(() => _index = value),
                      onVerify: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VerifyEmailScreen(),
                        ),
                      ),
                      onLogout: () => context.read<AuthViewModel>().logout(),
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        if (user?.isVerified == false)
                          _VerifyBanner(
                            onVerify: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const VerifyEmailScreen(),
                              ),
                            ),
                          ),
                        Expanded(
                          child: _screens[_index],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index > 4 ? 4 : _index,
                  onDestinationSelected: (value) {
                    if (value == 4) {
                      _showMoreSheet(context);
                    } else {
                      setState(() => _index = value);
                    }
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.storefront_rounded),
                      label: 'Store',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.shopping_bag_rounded),
                      label: 'Cart',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.calendar_month_rounded),
                      label: 'Booking',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.task_alt_rounded),
                      label: 'Tasks',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.menu_rounded),
                      label: 'More',
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _showMoreSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 4; i < _destinations.length; i++)
                ListTile(
                  leading: Icon(
                    _destinations[i].icon,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    _destinations[i].label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(_destinations[i].subtitle),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _index = i);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumSidebar extends StatelessWidget {
  const _PremiumSidebar({
    required this.selectedIndex,
    required this.destinations,
    required this.cartCount,
    required this.unreadCount,
    required this.userName,
    required this.userEmail,
    required this.verified,
    required this.onSelected,
    required this.onVerify,
    required this.onLogout,
  });

  final int selectedIndex;
  final List<_Destination> destinations;
  final int cartCount;
  final int unreadCount;
  final String userName;
  final String userEmail;
  final bool verified;
  final ValueChanged<int> onSelected;
  final VoidCallback onVerify;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292,
      margin: const EdgeInsets.fromLTRB(18, 6, 8, 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white),
        boxShadow: SoftShadow.strong,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDeep,
                    AppColors.primaryDark,
                    AppColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.devices_other_rounded,
                          color: Colors.white,
                          size: 31,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tech Store',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Admin dashboard',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Text(
                            userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                userEmail,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          verified ? Icons.verified_rounded : Icons.info_outline_rounded,
                          color: verified ? AppColors.lime : AppColors.warning,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: _MiniMetric(
                      label: 'Cart',
                      value: cartCount.toString(),
                      icon: Icons.shopping_bag_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniMetric(
                      label: 'Alerts',
                      value: unreadCount.toString(),
                      icon: Icons.notifications_rounded,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
                children: [
                  const _SidebarSectionTitle('MAIN MENU'),
                  for (var i = 0; i < destinations.length; i++)
                    _SidebarItem(
                      destination: destinations[i],
                      selected: selectedIndex == i,
                      count: i == 1 && cartCount > 0
                          ? cartCount
                          : i == 6 && unreadCount > 0
                              ? unreadCount
                              : null,
                      onTap: () => onSelected(i),
                    ),
                  const SizedBox(height: 12),
                  const _SidebarSectionTitle('ACCOUNT'),
                  _SmallActionTile(
                    icon: Icons.verified_user_rounded,
                    title: verified ? 'Account verified' : 'Verify account',
                    subtitle: verified ? 'Your profile is active' : 'Use code 123456',
                    onTap: onVerify,
                  ),
                  _SmallActionTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Exit from Tech Store',
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.destination,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withOpacity(0.10) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary.withOpacity(0.18) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  destination.icon,
                  color: selected ? Colors.white : AppColors.primaryDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: selected ? AppColors.primaryDark : AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      destination.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (count != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.muted,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallActionTile extends StatelessWidget {
  const _SmallActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

class _SidebarSectionTitle extends StatelessWidget {
  const _SidebarSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.muted,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}

class _VerifyBanner extends StatelessWidget {
  const _VerifyBanner({required this.onVerify});

  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.22),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Your account is not verified. Use code 123456 to activate it.',
            ),
          ),
          TextButton(
            onPressed: onVerify,
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _ShellBackground extends StatelessWidget {
  const _ShellBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.softBackground,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            right: 130,
            child: _Circle(
              size: 220,
              color: AppColors.primary.withOpacity(0.08),
            ),
          ),
          Positioned(
            bottom: -90,
            left: 380,
            child: _Circle(
              size: 260,
              color: AppColors.accent.withOpacity(0.12),
            ),
          ),
          Positioned(
            top: 240,
            right: -90,
            child: _Circle(
              size: 240,
              color: AppColors.primaryDark.withOpacity(0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Destination {
  const _Destination(
    this.label,
    this.subtitle,
    this.icon,
  );

  final String label;
  final String subtitle;
  final IconData icon;
}

class _Badge extends StatelessWidget {
  const _Badge({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
        right: 6,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
