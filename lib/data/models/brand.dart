class Brand {
  final String id;         // brandId
  final String name;       // brandName
  final String logo;       // brandLogo
  final String categoryId; // لربطها بتصنيف معين (اختياري)

  Brand({
    required this.id,
    required this.name,
    required this.logo,
    required this.categoryId,
  });

  factory Brand.fromMap(Map<String, dynamic> map, String docId) {
    return Brand(
      id: docId,
      name: map['name'] ?? '',
      logo: map['imageUrl'] ?? '',
      categoryId: map['categoryId'] ?? '',
    );
  }
}
