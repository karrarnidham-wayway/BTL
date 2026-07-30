import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/app_theme.dart';
import 'product_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: productsAsync.when(
        data: (products) {
          final product = products.firstWhere((p) => p.id == productId);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  color: AppColors.surface,
                  child: product.imageUrls.isNotEmpty
                      ? Image.network(product.imageUrls.first, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 80, color: AppColors.textSecondary),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name(locale.languageCode), style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text('${product.price.toStringAsFixed(2)} ₺',
                          style: const TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text(product.description(locale.languageCode)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ref.read(cartProvider.notifier).add(product.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(context.t('add_to_cart'))),
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart),
                              label: Text(context.t('add_to_cart')),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filled(
                            onPressed: () => launchUrl(Uri.parse('tel:+900000000000')),
                            icon: const Icon(Icons.call),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
