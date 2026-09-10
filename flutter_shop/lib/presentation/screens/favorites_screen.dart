import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final productsState = ref.watch(productsProvider);

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(22, 26, 22, 20),
            child: Text(
              'Mes favoris',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        ...favoritesState.when(
          loading: () => const [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          error: (error, stackTrace) => [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    'La liste de favoris n’est pas disponible pour le moment.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: AppTheme.ink.withValues(alpha: 0.65)),
                  ),
                ),
              ),
            ),
          ],
          data: (favoriteIds) {
            return productsState.when(
              loading: () => const [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (error, stackTrace) => const [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                      child: Text('Impossible de charger les produits.')),
                ),
              ],
              data: (products) {
                final favorites = products
                    .where((product) => favoriteIds.contains(product.id))
                    .toList();
                if (favorites.isEmpty) {
                  return const [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyFavorites(),
                    ),
                  ];
                }
                return [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = favorites[index];
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
                        childCount: favorites.length,
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
                ];
              },
            );
          },
        ),
      ],
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                color: AppTheme.mist,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border,
                  size: 32, color: AppTheme.sage),
            ),
            const SizedBox(height: 18),
            const Text(
              'Votre sélection est vide',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Touchez le cœur d’un produit pour le retrouver ici.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.ink.withValues(alpha: 0.62)),
            ),
          ],
        ),
      ),
    );
  }
}
