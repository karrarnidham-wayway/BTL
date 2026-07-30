import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../shared/models/product_model.dart';

final productListProvider = FutureProvider<List<ProductModel>>((ref) async {
  final response = await ApiClient.instance.client.get('/products');
  final List data = response.data as List;
  return data.map((json) => ProductModel.fromJson(json)).toList();
});

/// Sepet: basit local state (backend'e /cart endpoint'i ile senkron edilir).
final cartProvider = StateNotifierProvider<CartNotifier, Map<String, int>>((ref) => CartNotifier());

class CartNotifier extends StateNotifier<Map<String, int>> {
  CartNotifier() : super({});

  void add(String productId) {
    state = {...state, productId: (state[productId] ?? 0) + 1};
  }

  void remove(String productId) {
    if (!state.containsKey(productId)) return;
    final updated = {...state};
    if (updated[productId]! > 1) {
      updated[productId] = updated[productId]! - 1;
    } else {
      updated.remove(productId);
    }
    state = updated;
  }

  int get totalItemCount => state.values.fold(0, (a, b) => a + b);
}
