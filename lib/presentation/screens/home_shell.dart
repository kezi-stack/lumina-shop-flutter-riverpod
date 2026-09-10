import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  static const _pages = [
    CatalogScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(currentTabProvider);
    final cartCount = ref.watch(cartCountProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: selectedIndex, children: _pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(currentTabProvider.notifier).state = index;
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(Icons.grid_view_rounded, color: AppTheme.ink),
            label: 'Découvrir',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Panier',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
