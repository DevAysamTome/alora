import 'package:flutter/material.dart';
import '../data/models/cart_item.dart';
import '../data/models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// 🟢 **إضافة منتج (Product) إلى السلة**
  void addProduct(Product product, {String? selectedSize}) {
  // ابحث عما إذا كان المنتج موجودًا بالفعل في السلة
  int index = _items.indexWhere((existingItem) => existingItem.id == product.id);
  if (index != -1) {
    // إذا كان موجودًا، قم بزيادة الكمية بمقدار 1
    _items[index] = _items[index].copyWith(
      quantity: _items[index].quantity + 1,
    );
  } else {
    // احسب السعر بعد الخصم
    double discountedPrice = product.price - (product.price * product.discount / 100);

    // أنشئ CartItem جديد باستخدام بيانات المنتج
    final newItem = CartItem(
      id: product.id,
      name: product.name,
      quantity: 1,
      price: discountedPrice,
      imageUrl: product.imageUrl,
      // استخدم الحجم المختار إن وُجد، وإلا اختر أول حجم
size: selectedSize ?? (product.sizes.isNotEmpty ? product.sizes.first.name : null),
    );
    _items.add(newItem);
  }
  notifyListeners();
}


  /// 🟢 **إضافة عنصر (CartItem) جاهز إلى السلة**
  void addItem(CartItem item) {
    int index = _items.indexWhere((existingItem) => existingItem.id == item.id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  /// 🟢 **إزالة منتج من السلة**
  void removeItem(CartItem item) {
    _items.removeWhere((cartItem) => cartItem.id == item.id);
    notifyListeners();
  }

  /// 🟢 **زيادة كمية المنتج**
  void increaseQuantity(CartItem item) {
    int index = _items.indexWhere((existingItem) => existingItem.id == item.id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  /// 🟢 **إنقاص كمية المنتج**
  void decreaseQuantity(CartItem item) {
    int index = _items.indexWhere((existingItem) => existingItem.id == item.id);
    if (index != -1 && _items[index].quantity > 1) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity - 1,
      );
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  /// 🟢 **تفريغ السلة**
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
