import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../data/models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0; // لمراقبة المؤشر في السلايدر
  SizeOption? _selectedSize;      // الحجم المختار

  @override
  void initState() {
    super.initState();

    // إذا كان المنتج يحتوي على أحجام في product.sizes، اختر أول حجم بشكل افتراضي
if (widget.product.sizes.isNotEmpty) {
  _selectedSize = widget.product.sizes.first;
}
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final product = widget.product;
final basePrice = _selectedSize?.price ?? product.price;
    // جلب الصور من product.images إذا وجدت، وإلا استخدم صورة واحدة product.imageUrl
    final List<String> images =
        (product.images != null && product.images!.isNotEmpty)
            ? product.images!
            : [product.imageUrl];

    // خصم المنتج
    // إذا لم يتوفر product.discount، نحسبه من oldPrice/price أو نجعله 0
    final double discountPercent = product.discount.toDouble() ??
        (product.oldPrice != null
            ? ((product.oldPrice! - product.price) / product.oldPrice!) * 100
            : 0);
final discountedPrice = basePrice - (basePrice * product.discount / 100);
    // إذا كان هناك oldPrice
    final double? oldPrice = product.price;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            product.name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                // إضافة المنتج للمفضلة
                Provider.of<FavoritesProvider>(context, listen: false)
                    .addToFavorites(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تمت إضافة المنتج إلى المفضلة')),
                  
                );
                print(product.price);
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                // الذهاب إلى السلة أو تنفيذ منطق آخر
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown.shade300, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: kToolbarHeight + 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // سلايدر الصور
                  CarouselSlider(
                    items: images.map((imgUrl) {
                      return Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 300,
                      autoPlay: true,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() => _currentImageIndex = index);
                      },
                    ),
                  ),

                  // مؤشر السلايدر (رقم الصورة / العدد الكلي)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: Text(
                        '${_currentImageIndex + 1} / ${images.length}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                  // معلومات السعر والخصم
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // إذا كان هناك خصم
                            if (discountPercent > 0)
                              Row(
                                children: [
                                  Text(
                                    'خصم ${discountPercent.toStringAsFixed(2)}%',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  const SizedBox(width: 8),
                                  // إذا كان هناك oldPrice
                                  if (oldPrice != null)
                                    Text(
                                      oldPrice.toStringAsFixed(2),
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            const SizedBox(width: 8),
                            // السعر النهائي
                            Text(
                              discountedPrice.toStringAsFixed(2),
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '(شامل جميع الضرائب)',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // اختيار الأحجام (إن وجدت في product.sizes)
                  if (product.sizes != null && product.sizes!.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'اختر الحجم:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 8,
                        children: product.sizes!.map((size) {
                          return _buildSizeOption(size);
                        }).toList(),
                      ),
                    ),
                  ],

                  // زر "المزيد"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // يمكنك عرض شاشة أو توسيع تفاصيـل المنتج
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('المزيد'),
                          Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  ),

                  // الأزرار: اشترِ الآن + أضف للسلة
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown.shade300,
                            ),
                            child: const Text(
                              'اشترِ الآن',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              // منطق الشراء الآن
                              Provider.of<CartProvider>(context, listen: false)
                                  .addProduct(product);
                              Navigator.pushNamed(context, '/checkout');
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.brown.shade300, width: 2),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.brown.shade300,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              minimumSize: const Size(double.infinity, 36),
                            ),
                            child: const Text('أضف للسلة'),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addProduct(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تمت إضافة المنتج إلى السلة')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // تفاصيل المنتج
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تفاصيل المنتج',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ويدجت بناء زر الحجم
  Widget _buildSizeOption(SizeOption size) {
    final isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown.shade300 : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          size.name, // أو 'بوصة $size' إذا كان الحجم يمثل بوصات
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
