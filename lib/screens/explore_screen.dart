import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aloraapp/providers/cart_provider.dart';
import '../providers/products_provider.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGrid = true; // للتحكم في طريقة العرض (شبكة / قائمة)
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.products;

    // تصفية المنتجات بناءً على نص البحث
    final filteredProducts = products.where((product) {
      if (_searchQuery.isEmpty) return true;
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // نجعل الخلفية تمتد خلف الشريط العلوي
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('الاستكشاف',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            // زر للتحكم في عرض المنتجات (قائمة أو شبكة)
            // IconButton(
            //   icon: Icon(_isGrid ? Icons.list : Icons.grid_view),
            //   onPressed: () {
            //     setState(() => _isGrid = !_isGrid);
            //   },
            // ),
          ],
        ),
        body: Container(
          // خلفية متدرجة لإضفاء جمالية
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero, // إزالة الحواف الافتراضية
            children: [
              SizedBox(height: kToolbarHeight + 20),
              // شريط البحث
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSearchBar(),
              ),
              SizedBox(height: 10),

              // إذا المنتجات ما زالت تُحمّل
              if (productsProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(child: CircularProgressIndicator()),
                )
              // إذا لا توجد نتائج
              else if (filteredProducts.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      'لا توجد نتائج مطابقة',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              // وإلا عرض الشبكة أو القائمة
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                       _buildGridView(filteredProducts)
                      ,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// ويدجت حقل البحث بتصميم مميز
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن منتج...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  /// عرض المنتجات في شبكة (GridView)
  Widget _buildGridView(List products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // عدد الأعمدة
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  /// عرض المنتجات في قائمة (ListView)
  // Widget _buildListView(List products) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: products.length,
  //     itemBuilder: (context, index) {
  //       final product = products[index];
  //       return _buildProductCard(product);
  //     },
  //   );
  // }

  /// تصميم بطاقة المنتج بشكل أنيق
  Widget _buildProductCard(product) {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // معلومات المنتج
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // سعر وزر
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${product.price.toStringAsFixed(2)} ₪',
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 6),
          // زر التفاصيل أو الإضافة للسلة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        // لون الخط والسمك
                        side: BorderSide(color: Colors.brown.shade300, width: 2),
                        // خلفية بيضاء
                        backgroundColor: Colors.white,
                        // لون النص والأيقونات
                        foregroundColor: Colors.brown.shade300,
                        // شكل الزر (حواف مستديرة مثلاً)
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        // ارتفاع وعرض افتراضيين
                        minimumSize: Size(double.infinity, 36),
                      ),
                      child: Text('أضف للسلة'),
                      onPressed: () {
                        cartProvider.addProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تمت إضافة المنتج إلى السلة')),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
