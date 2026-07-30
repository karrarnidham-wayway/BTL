import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/app_theme.dart';
import 'product_provider.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final locale = ref.watch(localeProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('products')),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.gold,
                    child: Text('${ref.read(cartProvider.notifier).totalItemCount}',
                        style: const TextStyle(fontSize: 10, color: Colors.black)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Henüz ürün eklenmemiş'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final product = products[i];
              return GestureDetector(
                onTap: () => context.push('/product/${product.id}'),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: AppColors.surface,
                          width: double.infinity,
                          child: product.imageUrls.isNotEmpty
                              ? Image.network(product.imageUrls.first, fit: BoxFit.cover)
                              : const Icon(Icons.image, size: 48, color: AppColors.textSecondary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name(locale.languageCode),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${product.price.toStringAsFixed(2)} ₺',
                              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Ürünler yüklenemedi: $e')),
      ),
    );
  }
}
