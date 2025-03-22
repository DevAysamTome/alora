class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;
  final String? size;
  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.size
  });

  /// تحويل كائن `CartItem` إلى خريطة (Map) للاستخدام في Firestore أو API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'size': size
    };
  }

  /// إنشاء `CartItem` من خريطة (Map)، مفيد عند جلب البيانات من Firestore أو JSON
  factory CartItem.fromMap(Map<String, dynamic> data) {
    
    return CartItem(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      quantity: data['quantity']?.toInt() ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      size: data['size']
    );
  }

  /// إنشاء نسخة جديدة من `CartItem` مع إمكانية تعديل بعض الحقول
  CartItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size
    );
  }
}
