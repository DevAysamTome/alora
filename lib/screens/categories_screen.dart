import 'package:aloraapp/providers/categories_provider.dart';
import 'package:aloraapp/providers/colorsProvider.dart';
import 'package:aloraapp/screens/colors_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../data/models/category.dart';
import '../data/models/product.dart';
import 'product_details.dart'; // إن أردت شاشة تفاصيل المنتج

class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  const CategoryProductsScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  bool loading = true;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
  try {
    final snap = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: widget.category.id)
        .get();

    final fetchedProducts = snap.docs.map((doc) {
      final data = doc.data();

      // 1) اقرأ الحقل "sizes" من Firestore (قائمة من الكائنات)
      final rawSizes = data['sizes'] as List<dynamic>? ?? [];

      // 2) حوّل كل عنصر إلى SizeOption
      final sizeOptions = rawSizes.map((e) {
        return SizeOption.fromMap(e as Map<String, dynamic>);
      }).toList();

      // 3) أنشئ كائن Product ومرّر قائمة الأحجام
      return Product(
        id: doc.id,
        name: data['name'] ?? '',
        price: (data['price'] ?? 0.0).toDouble(),
        discount: (data['discount'] ?? 0),
        sizes: sizeOptions, // <-- هنا نمرر القائمة المحوّلة
        imageUrl: data['imageURL'] ?? '',
        category: data['categoryId'] ?? '',
        description: data['description'] ?? '',
        images: data['images'] == null
            ? []
            : List<String>.from(data['images']),
        oldPrice: (data['oldPrice'] ?? 0.0).toDouble(),
        isAvailable: data['isAvailable'] ?? true,
        quantity: data['quantity'] ?? 0
      );
    }).toList();

    setState(() {
      products = fetchedProducts;
      loading = false;
    });
  } catch (e) {
    print('خطأ في جلب منتجات الصنف: $e');
    setState(() {
      loading = false;
    });
  }
}


  @override
Widget build(BuildContext context) {
  final colorsProvider = Provider.of<ColorsProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final categories = categoriesProvider.categories;
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'منتجات ${widget.category.name}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown.shade300,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // قسم الألوان في الأعلى
                  SliverToBoxAdapter(
                    child: _buildColorsSection(colorsProvider, context,widget.category.id),
                  ),
                  // شبكة المنتجات مع بعض الحشوات الجانبية
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (ctx, index) {
                          final product = products[index];
                          return _buildProductCard(product);
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}


  // عنصر البطاقة في الشبكة
  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // الانتقال لشاشة تفاصيل المنتج
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white70,
                          size: 48,
                        ),
                      ),
              ),
            ),
            // معلومات المنتج
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price} ₪',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _buildColorsSection(ColorsProvider colorsProvider, BuildContext context, String categoryId) {
  if (colorsProvider.isLoading) {
    return Center(child: CircularProgressIndicator());
  }

  // تصفية الألوان حسب الصنف الحالي
  final filteredColors = colorsProvider.colors.where((colorObj) => colorObj.categoryId == categoryId).toList();

  if (filteredColors.isEmpty) {
    return SizedBox(); // أو يمكنك إرجاع Container() لإخفاء القسم إذا لم توجد ألوان مرتبطة
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الألوان",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredColors.length,
            itemBuilder: (ctx, index) {
              final colorObj = filteredColors[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ColorProductsScreen(colorId: colorObj.id),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        colorObj.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}


// دالة لتحويل string كـ "#FF0000" إلى Color
Color _parseColor(String colorCode) {
  if (colorCode.isEmpty) {
    return Colors.grey; // لون افتراضي
  }
  // إزالة علامة #
  final cleanCode = colorCode.replaceAll("#", "");
  // تحويله إلى int
  final hex = int.parse("FF$cleanCode", radix: 16);
  return Color(hex);
}
