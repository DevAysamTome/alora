import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aloraapp/data/models/brand.dart';
import 'package:aloraapp/data/models/product.dart';
import 'package:aloraapp/widgets/product_card.dart';

class BrandProductsScreen extends StatefulWidget {
  final Brand brand;

  const BrandProductsScreen({Key? key, required this.brand}) : super(key: key);

  @override
  _BrandProductsScreenState createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  bool loading = true;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchBrandProducts();
  }

  Future<void> _fetchBrandProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('brandId', isEqualTo: widget.brand.id)
          .get();

      final fetchedProducts = querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc);
      }).toList();

      setState(() {
        products = fetchedProducts;
        loading = false;
      });
    } catch (error) {
      print('خطأ في جلب منتجات الماركة: $error');
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // AppBar بتدرج لوني مميز
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          title: Text(
            'منتجات ${widget.brand.name}',
            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.brown.shade300,
                  Colors.brown.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        // خلفية بتدرج هادئ
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
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد منتجات لهذه الماركة',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.50,
                      ),
                      itemBuilder: (ctx, index) {
                        final product = products[index];
                        return ProductCardWithButtons(product: product);
                      },
                    ),
        ),
      ),
    );
  }
}
