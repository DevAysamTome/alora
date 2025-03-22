import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aloraapp/data/models/brand.dart';

class BrandsProvider with ChangeNotifier {
  List<Brand> _brands = [];
  bool _isLoading = false;

  List<Brand> get brands => _brands;
  bool get isLoading => _isLoading;

  Future<void> fetchBrands() async {
    _isLoading = true;
    notifyListeners();
    try {
      final snap = await FirebaseFirestore.instance
          .collection('brands')
          .get();

      _brands = snap.docs.map((doc) {
        final data = doc.data();
        return Brand.fromMap(data, doc.id);
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('خطأ في جلب الماركات: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
}
