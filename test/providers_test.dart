import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina_shop/data/models/product.dart';
import 'package:lumina_shop/presentation/providers/app_providers.dart';

void main() {
  const shirt = Product(
    id: 'shirt',
    name: 'Chemise Lin',
    category: 'Mode',
    description: 'Test',
    price: 89,
    rating: 4.8,
    imageUrl: '',
    colors: ['Sable'],
    isNew: true,
  );
  const mug = Product(
    id: 'mug',
    name: 'Tasse Alba',
    category: 'Maison',
    description: 'Test',
    price: 24,
    rating: 4.9,
    imageUrl: '',
    colors: ['Ivoire'],
    isNew: false,
  );

  test('le panier additionne, incrémente et supprime les articles', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.add(shirt);
    notifier.add(shirt);
    notifier.add(mug);

    expect(container.read(cartCountProvider), 3);
    expect(container.read(cartSubtotalProvider), 202);

    notifier.decrement(shirt.id);
    expect(container.read(cartCountProvider), 2);
    notifier.remove(mug.id);
    expect(container.read(cartCountProvider), 1);
  });

  test('le filtre recherche par nom et trie par prix', () async {
    final container = ProviderContainer(
      overrides: [
        productsProvider.overrideWith((ref) async => [shirt, mug]),
      ],
    );
    addTearDown(container.dispose);
    await container.read(productsProvider.future);
    final filter = container.read(productFilterProvider.notifier);

    filter.setCategory('Mode');
    expect(container.read(filteredProductsProvider), [shirt]);

    filter.setCategory('Tous');
    filter.setSort(SortOption.priceLowToHigh);
    expect(container.read(filteredProductsProvider).first, mug);

    filter.setQuery('chemise');
    expect(container.read(filteredProductsProvider), [shirt]);
  });
}
