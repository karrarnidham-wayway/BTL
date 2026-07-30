import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_client.dart';
import '../../../shared/models/product_model.dart';

/// Store Admin için ürün ekleme/düzenleme formu.
/// Görsel yükleme: image_picker ile seçilir, backend'e presigned S3 URL
/// üzerinden (MediaModule) yüklenir — bkz. backend planı Bölüm 9.6.
class ProductFormScreen extends StatefulWidget {
  final ProductModel? existingProduct;
  const ProductFormScreen({super.key, this.existingProduct});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late final TextEditingController _nameTrController;
  late final TextEditingController _nameArController;
  late final TextEditingController _descTrController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  XFile? _pickedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameTrController = TextEditingController(text: p?.nameTr ?? '');
    _nameArController = TextEditingController(text: p?.nameAr ?? '');
    _descTrController = TextEditingController(text: p?.descriptionTr ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _stockController = TextEditingController(text: p?.stockQuantity.toString() ?? '');
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _pickedImage = picked);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final payload = {
        'name_tr': _nameTrController.text,
        'name_ar': _nameArController.text,
        'description_tr': _descTrController.text,
        'price': double.tryParse(_priceController.text) ?? 0,
        'stock_quantity': int.tryParse(_stockController.text) ?? 0,
      };

      if (widget.existingProduct == null) {
        await ApiClient.instance.client.post('/store/products', data: payload);
      } else {
        await ApiClient.instance.client.patch('/store/products/${widget.existingProduct!.id}', data: payload);
      }
      // TODO: seçilen görsel varsa /store/products/:id/images'e ayrıca yükle
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existingProduct == null ? 'Yeni Ürün' : 'Ürünü Düzenle')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _pickedImage != null
                  ? const Center(child: Text('Görsel seçildi ✓'))
                  : const Center(child: Icon(Icons.add_a_photo, size: 40)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(controller: _nameTrController, decoration: const InputDecoration(labelText: 'Ürün Adı (TR)')),
          const SizedBox(height: 12),
          TextField(controller: _nameArController, decoration: const InputDecoration(labelText: 'اسم المنتج (AR)')),
          const SizedBox(height: 12),
          TextField(
            controller: _descTrController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Açıklama'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Fiyat (₺)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stok'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving ? const CircularProgressIndicator() : const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
