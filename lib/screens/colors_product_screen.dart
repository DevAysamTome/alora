import 'package:aloraapp/providers/products_provider.dart';
import 'package:aloraapp/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorProductsScreen extends StatelessWidget {
  final String colorId;
  const ColorProductsScreen({Key? key, required this.colorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final allProducts = productsProvider.products;

    // تصفية المنتجات التي لها اللون المحدد
    final colorProducts = allProducts.where((p) => p.color == colorId).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        
        // نستخدم CustomScrollView مع SliverAppBar لتصميم حديث وأنيق
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: CustomScrollView(
            slivers: [
              // شريط العنوان بتأثير ثابت أثناء التمرير
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.brown.shade300,
                centerTitle: true,
                title: const Text(
                  "منتجات اللون",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // عرض حالة التحميل أو عدم وجود منتجات
              if (productsProvider.isLoading)
                SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (colorProducts.isEmpty)
                SliverFillRemaining(
                  child: Center(child: Text("لا توجد منتجات لهذا اللون.")),
                )
              else
                // شبكة المنتجات مع بعض الحشوات لتباعد العناصر
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 0.10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (ctx, index) {
                        final product = colorProducts[index];
                        return ProductCardWithButtons(product: product);
                      },
                      childCount: colorProducts.length,
                    ),
                  ),
                ),
                
            ],
          ),
        ),
      ),
    );
  }
}
