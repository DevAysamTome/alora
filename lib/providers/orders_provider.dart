// providers/orders_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aloraapp/data/models/cart_item.dart';
import 'package:aloraapp/data/models/order.dart';

class OrdersProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // قائمة الطلبات (محليًا) إذا أردت عرضها في واجهة "طلباتي"
  List<OrderItem> _orders = [];
  List<OrderItem> get orders => _orders;

  /// إضافة طلب جديد إلى Firestore
  ///
  /// [cartItems]: عناصر السلة
  /// [total]: المجموع الكلي
  /// [name]: اسم المستخدم
  /// [phoneNumber]: رقم الهاتف
  /// [city], [village], [area], [street]: تفاصيل العنوان
  /// [status]: حالة الطلب (افتراضيًا "طلب جديد" إن لم تُمرّر)
  Future<void> addOrder({
    required List<CartItem> cartItems,
    required double total,
    required String name,
    required String phoneNumber,
    required String city,
    required String village,
    required String area,
    required String street,
    String status = 'طلب جديد', // إن لم يمرّر شيء، القيمة الافتراضية
  }) async {
    final dateTime = DateTime.now();
    try {
      // إعداد خريطة العنوان
      final addressMap = {
        'city': city,
        'village': village,
        'area': area,
        'street': street,
      };

      // إضافة مستند جديد في مجموعة "orders"
      DocumentReference docRef = await _firestore.collection('orders').add({
        'cartItems': cartItems.map((item) => item.toMap()).toList(),
        'total': total,
        'dateTime': dateTime.toIso8601String(),
        'name': name,
        'phoneNumber': phoneNumber,
        'address': addressMap,       // تخزين العنوان كـ خريطة
        'status': status.isEmpty ? 'طلب جديد' : status,
      });

      // إنشاء كائن Order محليًا (لو أردت الاحتفاظ به)
      final newOrder = OrderItem(
        id: docRef.id,
        cartItems: cartItems,
        total: total,
        dateTime: dateTime,
        name: name,
        phoneNumber: phoneNumber,
        // يمكنك حفظ العنوان في حقل واحد، أو كخريطة. مثلاً:
        addressLocation: '$city, $village, $area, $street',
        status: status.isEmpty ? 'طلب جديد' : status,
      );
      _orders.add(newOrder);
      notifyListeners();
    } catch (e) {
      print('خطأ أثناء إضافة الطلب: $e');
      rethrow; // أو يمكنك إظهار رسالة خطأ للمستخدم
    }
  }

  /// جلب الطلبات (لو أردت عرضها في واجهة "طلباتي")
  Future<void> fetchOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('orders').get();
      _orders = snapshot.docs.map((doc) {
        return OrderItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('خطأ أثناء جلب الطلبات: $e');
    }
  }
}
