import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../product_provider.dart';
import 'product_form_screen.dart';

/// Store Admin ana ekranı: ürün listesi + ekle/düzenle/sil.
/// Sadece role == store_admin veya super_admin olan kullanıcılar
/// backend tarafında bu endpoint'lere erişebilir (RBAC backend'de uygulanır).
class StoreAdminDashboard extends ConsumerWidget {
  const StoreAdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mağaza Yönetimi')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Ürün'),
      ),
      body: productsAsync.when(
        data: (products) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, i) {
            final product = products[i];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2, color: AppColors.gold),
                title: Text(product.nameTr),
                subtitle: Text('Stok: ${product.stockQuantity} · ${product.price.toStringAsFixed(2)} ₺'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProductFormScreen(existingProduct: product)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: AppColors.danger),
                      onPressed: () {
                        // TODO: DELETE /store/products/:id çağrısı + onay diyaloğu
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
