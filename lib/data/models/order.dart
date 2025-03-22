import 'package:aloraapp/data/models/cart_item.dart';

class OrderItem {
  final String id;
  final List<CartItem> cartItems;
  final double total;
  final DateTime dateTime;
  final String name;
  final String phoneNumber;
  final String addressLocation;
  final String status; // <-- الحقل الجديد

  OrderItem({
    required this.id,
    required this.cartItems,
    required this.total,
    required this.dateTime,
    required this.addressLocation,
    required this.name,
    required this.phoneNumber,
    required this.status,
  });

  // تحويل الطلب إلى خريطة (للتخزين في Firestore مثلاً)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'total': total,
      'dateTime': dateTime.toIso8601String(),
      'name': name,
      'phoneNumber': phoneNumber,
      'addressLocation': addressLocation,
      'status': status,
    };
  }

  // بناء Order من وثيقة Firestore
  factory OrderItem.fromMap(Map<String, dynamic> data, String docId) {
    return OrderItem(
      id: docId,
      cartItems: (data['cartItems'] as List)
          .map((e) => CartItem.fromMap(e))
          .toList(),
      total: (data['total'] ?? 0.0).toDouble(),
      dateTime: DateTime.parse(data['dateTime']),
      addressLocation: data['addressLocation'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      status: data['status'] ?? 'طلب جديد', // إذا لم يوجد، نضع افتراضي
    );
  }
}
