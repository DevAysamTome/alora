import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aloraapp/data/models/product.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs.map((doc) => Product(
      id: doc.id,
      name: doc['title'],
      description: doc['description'],
      price: doc['price'],
      imageUrl: doc['imageUrl'],
      oldPrice: 0.0,
      category: doc['categoryId'],
      sizes: doc['sizes'],
      discount: doc['discount'],
      images: doc['imageUrl'],
      quantity: doc['quantity'],
isAvailable: doc['isAvailable']
    )).toList();
  }
}