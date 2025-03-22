import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addCategories() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> categories = [
    {"id": "electronics", "name": "Electronics"},
    {"id": "fashion", "name": "Fashion"},
    {"id": "home_appliances", "name": "Home Appliances"},
    {"id": "sports", "name": "Sports"},
    {"id": "beauty", "name": "Beauty & Health"},
  ];

  for (var category in categories) {
    await _firestore.collection('categories').doc(category['id']).set(category);
  }

  print('✅ التصنيفات أضيفت بنجاح!');
}

Future<void> addProducts() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> products = [
    {
      "id": "X1A3Z0K4",
      "name": "Smartphone",
      "price": 499.99,
      "description": "Latest model with high performance.",
      "imageUrl": "https://via.placeholder.com/150",
      "categoryId": "electronics"
    },
    {
      "id": "P72HD29A",
      "name": "Wireless Headphones",
      "price": 189.99,
      "description": "Noise cancelling wireless headphones.",
      "imageUrl": "https://via.placeholder.com/150",
      "categoryId": "electronics"
    }
  ];

  for (var product in products) {
    await _firestore.collection('products').add(product);
  }

  print('✅ المنتجات أضيفت بنجاح!');
}
