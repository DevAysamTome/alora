import 'package:aloraapp/data/models/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ColorsProvider with ChangeNotifier {
  List<ColorModel> _colors = [];
  bool isLoading = false;

  List<ColorModel> get colors => _colors;

  Future<void> fetchColors() async {
    isLoading = true;
    notifyListeners();
    try {
      final snap = await FirebaseFirestore.instance.collection("colors").get();
      _colors = snap.docs.map((doc) {
        final data = doc.data();
        return ColorModel(
          id: doc.id,
          name: data["name"] ?? "",
          colorCode: data["colorCode"] ?? "",
          categoryId: data['categoryId'] ?? ''
        );
      }).toList();
    } catch (e) {
      print("خطأ في جلب الألوان: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
