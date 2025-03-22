import 'package:flutter/material.dart';
import '../data/models/product.dart';

class FavoritesProvider with ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  /// إضافة منتج للمفضلة
  void addToFavorites(Product product) {
    // تأكد من عدم تكرار المنتج
    if (!_favorites.contains(product)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  /// إزالة منتج من المفضلة
  void removeFromFavorites(Product product) {
    _favorites.remove(product);
    notifyListeners();
  }

  /// التحقق إن كان المنتج مضافًا للمفضلة
  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }
}
