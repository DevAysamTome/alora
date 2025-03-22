import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aloraapp/screens/categories_screen.dart';

import '../data/models/category.dart';
import '../providers/categories_provider.dart';

// شاشة عرض التصنيفات بنمط شبكي متطور
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // جلب التصنيفات من المزوّد
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final categories = categoriesProvider.categories; // List<Category>

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التصنيفات'),
          backgroundColor: Colors.brown.shade300,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.brown.shade300,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عرض عنصرين في الصف الواحد
                childAspectRatio: 1, // الحفاظ على نسبة العرض للارتفاع متساوية
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (ctx, index) {
                final category = categories[index];
                return _buildCategoryGridItem(context, category);
              },
            ),
          ),
        ),
      ),
    );
  }

  // عنصر شبكة للتصنيف مع تأثيرات بصرية متطورة
  Widget _buildCategoryGridItem(BuildContext context, Category category) {
    return GestureDetector(
      onTap: () {
        // الانتقال لشاشة منتجات التصنيف عند النقر
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductsScreen(category: category),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // خلفية الصورة في حال توفرها
            if (category.imageUrl != null && category.imageUrl!.isNotEmpty)
              Image.network(
                category.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) =>
                    Container(color: Colors.grey.shade300),
              )
            else
              Container(color: Colors.grey.shade300),
            // تأثير تراكبي لتعزيز وضوح النصوص
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // عرض اسم التصنيف في أسفل البطاقة
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
