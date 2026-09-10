import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/cart_item.dart';
import '../providers/app_providers.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/remote_product_image.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final currency = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
            child: Row(
              children: [
                const Text(
                  'Votre panier',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                if (items.isNotEmpty)
                  TextButton(
                    onPressed: ref.read(cartProvider.notifier).clear,
                    child: const Text('Tout retirer'),
                  ),
              ],
            ),
          ),
        ),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyCart(),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return _CartRow(
                  item: items[index],
                  currency: currency,
                  onIncrement: () => ref
                      .read(cartProvider.notifier)
                      .increment(items[index].product.id),
                  onDecrement: () => ref
                      .read(cartProvider.notifier)
                      .decrement(items[index].product.id),
                  onRemove: () => ref
                      .read(cartProvider.notifier)
                      .remove(items[index].product.id),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 36),
              child: Column(
                children: [
                  _SummaryRow(
                      label: 'Sous-total', value: currency.format(subtotal)),
                  const SizedBox(height: 9),
                  const _SummaryRow(label: 'Livraison', value: 'Offerte'),
                  const Divider(height: 30),
                  _SummaryRow(
                    label: 'Total',
                    value: currency.format(subtotal),
                    emphasized: true,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () => _showCheckout(context),
                      child: const Text(
                        'Passer la commande',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showCheckout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Commande confirmée'),
        content: const Text(
          'Merci pour votre confiance. Ceci est une simulation de commande pour le projet de certification.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.item,
    required this.currency,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final NumberFormat currency;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 96,
            child: RemoteProductImage(
                url: item.product.imageUrl, borderRadius: 14),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  currency.format(item.product.price),
                  style: TextStyle(color: AppTheme.ink.withValues(alpha: 0.62)),
                ),
                const SizedBox(height: 10),
                QuantityStepper(
                  quantity: item.quantity,
                  onDecrement: onDecrement,
                  onIncrement: onIncrement,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close, size: 18),
                tooltip: 'Supprimer',
              ),
              const SizedBox(height: 11),
              Text(
                currency.format(item.total),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasized ? 17 : 14,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasized ? 18 : 14,
            fontWeight: FontWeight.w800,
            color: emphasized
                ? AppTheme.ink
                : AppTheme.ink.withValues(alpha: 0.76),
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

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
              child: const Icon(Icons.shopping_bag_outlined,
                  size: 32, color: AppTheme.sage),
            ),
            const SizedBox(height: 18),
            const Text(
              'Votre panier est vide',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Les pièces que vous choisissez apparaîtront ici.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.ink.withValues(alpha: 0.62)),
            ),
          ],
        ),
      ),
    );
  }
}
