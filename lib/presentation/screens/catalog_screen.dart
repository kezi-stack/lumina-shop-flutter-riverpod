import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);
    final products = ref.watch(filteredProductsProvider);
    final filter = ref.watch(productFilterProvider);
    final categories = ref.watch(categoriesProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(productsProvider.future),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
              child: _CatalogHeader(
                query: filter.query,
                onQueryChanged: (value) =>
                    ref.read(productFilterProvider.notifier).setQuery(value),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
              child: _CategoryChips(
                categories: categories,
                selected: filter.category,
                onSelected: (value) =>
                    ref.read(productFilterProvider.notifier).setCategory(value),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
              child: Row(
                children: [
                  const Text(
                    'La sélection',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  _SortButton(
                    selected: filter.sort,
                    onSelected: (sort) =>
                        ref.read(productFilterProvider.notifier).setSort(sort),
                  ),
                ],
              ),
            ),
          ),
          ...productsState.when(
            loading: () => [
              const SliverToBoxAdapter(child: _LoadingGrid()),
            ],
            error: (error, stackTrace) => [
              SliverToBoxAdapter(
                child: _ErrorState(
                  onRetry: () => ref.invalidate(productsProvider),
                ),
              ),
            ],
            data: (_) => products.isEmpty
                ? const [SliverToBoxAdapter(child: _EmptySearchState())]
                : [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: product),
                                ),
                              ),
                            );
                          },
                          childCount: products.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 22,
                          childAspectRatio: 0.61,
                        ),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader({
    required this.query,
    required this.onQueryChanged,
  });

  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.ink,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 19),
            ),
            const SizedBox(width: 10),
            const Text(
              'LUMINA',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 3),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Text(
          'Des objets qui\nracontent votre histoire.',
          style: TextStyle(
              fontSize: 31, height: 1.08, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Text(
          'Une sélection sensible, pensée pour le quotidien.',
          style: TextStyle(
              color: AppTheme.ink.withValues(alpha: 0.64), fontSize: 14),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Rechercher une pièce...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    onPressed: () => onQueryChanged(''),
                    icon: const Icon(Icons.close),
                    tooltip: 'Effacer',
                  ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selected == category,
                  onSelected: (_) => onSelected(category),
                  selectedColor: AppTheme.ink,
                  labelStyle: TextStyle(
                    color: selected == category ? Colors.white : AppTheme.ink,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.selected, required this.onSelected});

  final SortOption selected;
  final ValueChanged<SortOption> onSelected;

  String get _label {
    switch (selected) {
      case SortOption.featured:
        return 'À la une';
      case SortOption.priceLowToHigh:
        return 'Prix ↑';
      case SortOption.priceHighToLow:
        return 'Prix ↓';
      case SortOption.rating:
        return 'Avis';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(value: SortOption.featured, child: Text('À la une')),
        PopupMenuItem(
            value: SortOption.priceLowToHigh, child: Text('Prix croissant')),
        PopupMenuItem(
            value: SortOption.priceHighToLow, child: Text('Prix décroissant')),
        PopupMenuItem(value: SortOption.rating, child: Text('Mieux notés')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tune_rounded, size: 16),
            const SizedBox(width: 6),
            Text(_label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 40, 22, 40),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 40, color: AppTheme.sage),
          const SizedBox(height: 12),
          const Text('Impossible de charger la sélection.',
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 40, 22, 40),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: AppTheme.sage),
          SizedBox(height: 12),
          Text('Aucun objet ne correspond à votre recherche.'),
        ],
      ),
    );
  }
}
