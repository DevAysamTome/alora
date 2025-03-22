import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/category.dart';

class CategoriesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 🟢 **جلب التصنيفات من Firestore**
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();
      _categories = snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();

      // إذا لم يكن هناك بيانات في Firestore، يتم استخدام قائمة افتراضية
    
    } catch (e) {
      _error = "خطأ أثناء جلب التصنيفات: $e";
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔵 **توفير قائمة افتراضية عند عدم وجود تصنيفات في Firestore**
  
}
