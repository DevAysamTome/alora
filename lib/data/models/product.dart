import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double oldPrice;
  final String description;
  final String imageUrl;
  final String category;
  final int discount;
  final List<String> images;
  final bool isAvailable;
  final int quantity;
  final List<SizeOption> sizes;
    String? color;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.oldPrice,
    required this.category,
    required this.sizes,
    required this.discount,
    required this.images,
    required this.isAvailable,
    required this.quantity,
    this.color
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // معالجة الحقل sizes وتحويله إلى قائمة من SizeOption
    final rawSizes = data['sizes'] as List<dynamic>? ?? [];
    final fetchedSizes = rawSizes.map((e) {
      return SizeOption.fromMap(e as Map<String, dynamic>);
    }).toList();

    // معالجة قيمة الخصم لضمان تحويلها إلى int إذا كانت مخزنة كسلسلة
    int discountVal;
    var rawDiscount = data['discount'] ?? 0;
    if (rawDiscount is String) {
      discountVal = int.tryParse(rawDiscount) ?? 0;
    } else if (rawDiscount is num) {
      discountVal = rawDiscount.toInt();
    } else {
      discountVal = 0;
    }

    // معالجة قيمة السعر لضمان تحويلها إلى double إذا كانت مخزنة كسلسلة
    double priceVal;
    var rawPrice = data['price'] ?? 0.0;
    if (rawPrice is String) {
      priceVal = double.tryParse(rawPrice) ?? 0.0;
    } else if (rawPrice is num) {
      priceVal = rawPrice.toDouble();
    } else {
      priceVal = 0.0;
    }

    // معالجة قيمة السعر القديم بنفس الطريقة
    double oldPriceVal;
    var rawOldPrice = data['oldPrice'] ?? 0.0;
    if (rawOldPrice is String) {
      oldPriceVal = double.tryParse(rawOldPrice) ?? 0.0;
    } else if (rawOldPrice is num) {
      oldPriceVal = rawOldPrice.toDouble();
    } else {
      oldPriceVal = 0.0;
    }

    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: priceVal,
      oldPrice: oldPriceVal,
      description: data['description'] ?? '',
      imageUrl: data['imageURL'] ?? '',
      category: data['categoryId'] ?? '',
      discount: discountVal,
      images: data['images'] == null ? [] : List<String>.from(data['images']),
      sizes: fetchedSizes,
      isAvailable: data['isAvailable'] ?? true,
      quantity: data['quantity'] ?? 0,
      color: data['color']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'oldPrice': oldPrice,
      'description': description,
      'imageURL': imageUrl,
      'categoryId': category,
      'discount': discount,
      'images': images,
      'sizes': sizes.map((s) => s.toMap()).toList(),
      'isAvailable': isAvailable,
      'quantity': quantity,
    };
  }
}

class SizeOption {
  final String name;
  final double price;

  SizeOption({required this.name, required this.price});

  factory SizeOption.fromMap(Map<String, dynamic> map) {
    var priceVal = map['price'] ?? 0.0;
    double convertedPrice;
    if (priceVal is String) {
      convertedPrice = double.tryParse(priceVal) ?? 0.0;
    } else if (priceVal is num) {
      convertedPrice = priceVal.toDouble();
    } else {
      convertedPrice = 0.0;
    }
    return SizeOption(
      name: map['name'] ?? '',
      price: convertedPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}
