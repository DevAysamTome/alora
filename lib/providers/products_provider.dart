import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/product.dart';

class ProductsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Product> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument; // آخر مستند تم تحميله
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  /// 🟢 **جلب أول دفعة من المنتجات**
  Future<void> fetchInitialProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Query query = _firestore.collection('products')
          .orderBy('name') // ترتيب حسب الاسم، يمكن تغييره
          .limit(100); // تحديد عدد المنتجات في كل طلب

      QuerySnapshot snapshot = await query.get();
      _products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        print(snapshot.docs.length);
      // حفظ آخر مستند تم تحميله
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      _hasMore = snapshot.docs.length == 10;
    } catch (e) {
      _error = "خطأ أثناء جلب المنتجات: $e";
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔵 **تحميل المزيد من المنتجات (Lazy Loading)**
  Future<void> fetchNextProducts() async {
    if (_isLoadingMore || !_hasMore) return; // منع التحميل المتكرر أو في حال عدم وجود المزيد
    
    _isLoadingMore = true;
    _error = null;
    notifyListeners();

    try {
      Query query = _firestore.collection('products')
          .orderBy('name')
          .limit(10);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot snapshot = await query.get();
      final newProducts = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      
      if (newProducts.isNotEmpty) {
        _products.addAll(newProducts);
        _lastDocument = snapshot.docs.last;
      }

      _hasMore = snapshot.docs.length == 10;
    } catch (e) {
      _error = "خطأ أثناء تحميل المزيد من المنتجات: $e";
      print(_error);
      _hasMore = false;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
  Future<void> fetchProductsByCategory(String categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      Query query = _firestore.collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('name')
          .limit(10);

      QuerySnapshot snapshot = await query.get();
      _products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();

      _hasMore = snapshot.docs.length == 10;
    } catch (e) {
      _error = "خطأ أثناء جلب المنتجات: $e";
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
