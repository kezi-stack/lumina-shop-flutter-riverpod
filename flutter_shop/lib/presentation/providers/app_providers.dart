import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';
import '../../data/models/profile.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(),
);

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).fetchProducts();
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

final favoritesRepositoryProvider = FutureProvider<FavoritesRepository>(
  (ref) async {
    final preferences = await ref.watch(sharedPreferencesProvider.future);
    return FavoritesRepository(preferences);
  },
);

class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final repository = await ref.watch(favoritesRepositoryProvider.future);
    return repository.readIds();
  }

  Future<void> toggle(String productId) async {
    final repository = await ref.read(favoritesRepositoryProvider.future);
    final current = state.valueOrNull ?? <String>{};
    final next = {...current};
    if (!next.add(productId)) {
      next.remove(productId);
    }
    state = AsyncData(next);
    await repository.writeIds(next);
  }

  bool isFavorite(String productId) {
    return state.valueOrNull?.contains(productId) ?? false;
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);

enum SortOption { featured, priceLowToHigh, priceHighToLow, rating }

class ProductFilter {
  const ProductFilter({
    this.query = '',
    this.category = 'Tous',
    this.sort = SortOption.featured,
  });

  final String query;
  final String category;
  final SortOption sort;

  ProductFilter copyWith({
    String? query,
    String? category,
    SortOption? sort,
  }) {
    return ProductFilter(
      query: query ?? this.query,
      category: category ?? this.category,
      sort: sort ?? this.sort,
    );
  }
}

class ProductFilterNotifier extends StateNotifier<ProductFilter> {
  ProductFilterNotifier() : super(const ProductFilter());

  void setQuery(String value) => state = state.copyWith(query: value);
  void setCategory(String value) => state = state.copyWith(category: value);
  void setSort(SortOption value) => state = state.copyWith(sort: value);
  void reset() => state = const ProductFilter();
}

final productFilterProvider =
    StateNotifierProvider<ProductFilterNotifier, ProductFilter>(
  (ref) => ProductFilterNotifier(),
);

final categoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productsProvider).valueOrNull ?? <Product>[];
  final categories = products.map((product) => product.category).toSet().toList();
  categories.sort();
  return ['Tous', ...categories];
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider).valueOrNull ?? <Product>[];
  final filter = ref.watch(productFilterProvider);
  final normalizedQuery = filter.query.trim().toLowerCase();
  final filtered = products.where((product) {
    final matchesQuery = normalizedQuery.isEmpty ||
        product.name.toLowerCase().contains(normalizedQuery) ||
        product.category.toLowerCase().contains(normalizedQuery);
    final matchesCategory =
        filter.category == 'Tous' || product.category == filter.category;
    return matchesQuery && matchesCategory;
  }).toList();

  switch (filter.sort) {
    case SortOption.priceLowToHigh:
      filtered.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceHighToLow:
      filtered.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.rating:
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    case SortOption.featured:
      filtered.sort((a, b) {
        if (a.isNew == b.isNew) return b.rating.compareTo(a.rating);
        return a.isNew ? -1 : 1;
      });
  }
  return filtered;
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  void add(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      state = [...state, CartItem(product: product, quantity: 1)];
      return;
    }
    final updated = [...state];
    updated[index] = updated[index].copyWith(quantity: updated[index].quantity + 1);
    state = updated;
  }

  void increment(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    final updated = [...state];
    updated[index] = updated[index].copyWith(quantity: updated[index].quantity + 1);
    state = updated;
  }

  void decrement(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    final item = state[index];
    if (item.quantity <= 1) {
      remove(productId);
      return;
    }
    final updated = [...state];
    updated[index] = item.copyWith(quantity: item.quantity - 1);
    state = updated;
  }

  void remove(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void clear() => state = const [];
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(0, (total, item) => total + item.quantity);
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold(0, (total, item) => total + item.total);
});

final profileProvider = Provider<Profile>(
  (ref) => const Profile(
    name: 'Camille Martin',
    email: 'camille.martin@example.com',
    initials: 'CM',
    ordersCount: 12,
    points: 680,
  ),
);

final currentTabProvider = StateProvider<int>((ref) => 0);