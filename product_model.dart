class ProductModel {
  final String id;
  final String nameTr;
  final String nameAr;
  final String descriptionTr;
  final String descriptionAr;
  final double price;
  final int stockQuantity;
  final List<String> imageUrls;

  ProductModel({
    required this.id,
    required this.nameTr,
    required this.nameAr,
    required this.descriptionTr,
    required this.descriptionAr,
    required this.price,
    required this.stockQuantity,
    required this.imageUrls,
  });

  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameTr;
  String description(String languageCode) => languageCode == 'ar' ? descriptionAr : descriptionTr;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      nameTr: json['name_tr'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      descriptionTr: json['description_tr'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      imageUrls: (json['image_urls'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
