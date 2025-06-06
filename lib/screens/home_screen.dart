import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aloraapp/data/models/category.dart';
import 'package:aloraapp/data/models/product.dart';
import 'package:aloraapp/providers/brands_provider.dart';
import 'package:aloraapp/providers/cart_provider.dart';
import 'package:aloraapp/screens/brand_product_screen.dart';
import 'package:aloraapp/screens/categories_screen.dart';
import 'package:aloraapp/screens/product_details.dart';
import 'package:aloraapp/widgets/brandItem.dart';
import 'package:aloraapp/widgets/custom_button.dart';
import 'package:aloraapp/widgets/footer_widget.dart';
import '../providers/categories_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/promo_slider.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentIndex = 0;
  bool isSearch = false;
  // List<String> promoImages = [
  //   'https://www.shutterstock.com/image-vector/sale-off-discount-promotion-set-600nw-2389397201.jpg',
  //   'https://www.shutterstock.com/image-vector/white-friday-arabic-calligraphy-sale-260nw-2216166673.jpg',
  //   'https://www.shutterstock.com/image-vector/free-shipping-delivery-white-arabic-260nw-2537471247.jpg',
  // ];
  Future<List<String>> fetchPromoImages() async {
    try {
      final querySnap =
          await FirebaseFirestore.instance.collection('promo-images').get();

      // نفترض أن كل مستند يحوي حقل 'imageUrl'
      final images =
          querySnap.docs.map((doc) {
            final data = doc.data();
            return data['imageUrl'] as String; // تأكد أن الحقل موجود
          }).toList();

      return images;
    } catch (e) {
      print('خطأ في جلب صور العروض: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPromoImages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    final productsProvider = Provider.of<ProductsProvider>(context);
    final brandsProvider = Provider.of<BrandsProvider>(context);

    final products = productsProvider.products;

    final filteredProducts =
        products.where((product) {
          if (_searchQuery.isEmpty) return true;
          return product.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
        }).toList();

    // تغليف الشاشة كلها بـ Directionality لفرض RTL
return Directionality(
  textDirection: TextDirection.rtl,
  child: Scaffold(
    extendBodyBehindAppBar: true,
    appBar: _buildCustomAppBar(
      context,
      _searchController,
      (value) => setState(() => isSearch = value.isNotEmpty),
      () => setState(() {
        _searchController.clear();
        isSearch = false;
      }),
    ),
    bottomNavigationBar: CustomBottomNavBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        switch (index) {
          case 0: Navigator.pushReplacementNamed(context, '/home'); break;
          case 1: Navigator.pushNamed(context, '/cart'); break;
          case 2: Navigator.pushNamed(context, '/explore-screen'); break;
          case 3: Navigator.pushNamed(context, '/favorites'); break;
          case 4: Navigator.pushNamed(context, '/categories'); break;
        }
      },
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown.shade300, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),

                if (!isSearch) ...[
                  _buildCategorySection(categoriesProvider),

                  FutureBuilder<List<String>>(
                    future: fetchPromoImages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('خطأ في جلب الصور: ${snapshot.error}'));
                      }
                      return PromoSlider(images: snapshot.data ?? []);
                    },
                  ),

                  _buildSectionHeader('وصلنا حديثًا', onTap: () {
                    Navigator.pushNamed(context, '/explore-screen');
                  }),

                  _buildFeaturedSection(productsProvider),

                  _buildSectionHeader('الماركات المميزة'),
                  _buildBrandSection(brandsProvider),

                  _buildSectionHeader('عروض وخصومات', onTap: () {
                    Navigator.pushNamed(context, '/explore-screen');
                  }),

                  _buildDiscountSection(productsProvider),

                  _buildCategorySectionList(productsProvider),

                  const SizedBox(height: 30),
                  FooterWidget(),
                  const SizedBox(height: 30),
                ] else ...[
                  _buildGridView(filteredProducts),
                ],
              ],
            ),
          ),
        );
      },
    ),
  ),
);
  }

Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text('عرض الكل', style: TextStyle(color: Colors.brown.shade300)),
          ),
      ],
    ),
  );
}

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
                  borderRadius: BorderRadius.circular(8),
                ),
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

PreferredSizeWidget _buildCustomAppBar(BuildContext context, TextEditingController searchController, Function(String) onSearchChanged, VoidCallback onSearchClear) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(150), 
    child: Stack(
      children: [
        // خلفية Lottie
        // Positioned.fill(
        //   child: ClipRRect(
        //     borderRadius: const BorderRadius.only(
        //       bottomLeft: Radius.circular(0),
        //       bottomRight: Radius.circular(0),
        //     ),
        //     child: Lottie.asset('assets/animation.json', fit: BoxFit.cover),
        //   ),
        // ),

        // محتوى الـ AppBar فوق Lottie
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/favorites'),
                ),
                
                const Spacer(),
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/alora_logo.png'),
                ),
              ],
            ),
          ),
          centerTitle: false,
        ),

        // صندوق البحث في الأسفل
        Positioned(
          bottom: 10,
          left: 16,
          right: 16,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: onSearchClear,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
              ),
              onChanged: onSearchChanged,
            ),
          ),
        ),
      ],
    ),
  );
}



  Widget _buildCategorySection(CategoriesProvider categoriesProvider) {
    final categories = categoriesProvider.categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'تسوّق حسب التصنيف',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 100,
          child:
              categoriesProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, i) {
                      final cat = categories[i];
                      return CategoryItem(category: cat);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildBrandSection(BrandsProvider brandsProvider) {
    if (brandsProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final brands = brandsProvider.brands;
    if (brands.isEmpty) {
      return const Center(child: Text('لا توجد ماركات حالياً.'));
    }
    return Container(
      height: 120, // مثلاً
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return BrandItem(
            brand: brand,
            onTap: () {
              // الانتقال إلى شاشة تعرض منتجات هذه الماركة
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BrandProductsScreen(brand: brand),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection(ProductsProvider productsProvider) {
  if (productsProvider.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  
  final products = productsProvider.products;
  print("Products length: ${products.length}");
  if (products.isEmpty) {
    return const Center(child: Text('لا يوجد منتجات مميزة حالياً.'));
  }
  
  // عرض المنتجات بدون فرز للتأكد من ظهورها
  return Container(
    height: 400,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        final product = products[index];
        print("Displaying product: ${product.name}");
        return Container(
          width: 300,
          margin: const EdgeInsets.only(right: 8),
          child: ProductCardWithButtons(product: product),
        );
      },
    ),
  );
}


Widget _buildCategorySectionList(ProductsProvider productsProvider) {
  if (productsProvider.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  // جلب جميع المنتجات
  final allProducts = productsProvider.products;
  // استخراج الأصناف الفريدة
  final categories = allProducts.map((p) => p.category).toSet().toList();

  if (categories.isEmpty) {
    return const Center(child: Text('لا توجد أصناف متاحة حالياً.'));
  }

  return SingleChildScrollView(
    child: Column(
      children: categories.map((category) {
        // تصفية المنتجات الخاصة بكل صنف
        final categoryProducts =
            allProducts.where((p) => p.category == category).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الصنف بتنسيق يشابه عرض المنتجات المضافة حديثاً
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // قائمة أفقية لعرض منتجات الصنف مع تحديد ارتفاع ثابت
            Container(
              height: 420,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryProducts.length,
                itemBuilder: (context, index) {
                  final product = categoryProducts[index];
                  return Container(
                    width: 350,
                    margin: const EdgeInsets.only(right: 8),
                    child: ProductCardWithButtons(product: product),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    ),
  );
}






Widget _buildDiscountSection(ProductsProvider productsProvider) {
    if (productsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // جلب جميع المنتجات
    final allProducts = productsProvider.products;
    // تصفية المنتجات التي لديها خصم
    final discountProducts = allProducts.where((p) => p.discount > 0).toList();

    if (discountProducts.isEmpty) {
      return const Center(child: Text('لا يوجد منتجات عليها خصم حالياً.'));
    }

    return Container(
      height: 420,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: discountProducts.length,
        itemBuilder: (ctx, index) {
          final product = discountProducts[index];
          return Container(
            width: 350,
            margin: const EdgeInsets.only(right: 8),
            child: ProductCardWithButtons(product: product),
          );
        },
      ),
    );
  }


}
