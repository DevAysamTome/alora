import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String imageUrl;
  Category({required this.id, required this.name,required this.imageUrl});

  /// 🟢 **تحويل وثيقة Firestore إلى كائن Category**
  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      
      name: data['name'] ?? 'Unnamed Category',
      imageUrl: data['imageUrl']
    );
  }

  /// 🔵 **تحويل كائن Category إلى JSON (Firestore Format)**
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl':imageUrl
    };
  }
}
