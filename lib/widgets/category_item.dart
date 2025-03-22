import 'package:flutter/material.dart';
import 'package:aloraapp/screens/categories_screen.dart';
import '../data/models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // الانتقال لشاشة تعرض منتجات هذا الصنف
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              category: category, // أو تمرر الكائن كله
            ),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(category.imageUrl),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
