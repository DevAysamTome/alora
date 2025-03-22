import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aloraapp/data/models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items; // قائمة بعناصر السلة
    final totalAmount = cartProvider.totalAmount; // المجموع الكلي

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // خلفية بسيطة بلون متدرج مثلاً
        extendBodyBehindAppBar: true, // لجعل الخلفية تمتد خلف شريط التطبيق
        appBar: AppBar(
          title: const Text('سلة التسوق',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    SizedBox(height: kToolbarHeight + 10), // إزاحة عن شريط التطبيق
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (ctx, index) {
                          final item = cartItems[index];
                          return _buildCartItem(context, item, cartProvider);
                        },
                      ),
                    ),
                    _buildCartSummary(context, totalAmount, cartItems),
                  ],
                ),
        ),
      ),
    );
  }

  /// ويدجت في حال السلة فارغة
  Widget _buildEmptyCart() {
    return Center(
      child: Text(
        'سلتك فارغة',
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// بناء بطاقة عنصر السلة
  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cartProvider) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(item.imageUrl), // تأكد أن CartItem يحوي imageUrl
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  // سعر المنتج * الكمية
                  Text(
                    'السعر: ${(item.price * item.quantity).toStringAsFixed(2)} ',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  // مؤشر الكمية
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () => cartProvider.decreaseQuantity(item),
                      ),
                      Text(
                        '${item.quantity}',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () => cartProvider.increaseQuantity(item),
                      ),
                      Spacer(),
                      // زر حذف
                      IconButton(
                        icon: Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () => cartProvider.removeItem(item),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// قسم ملخص السلة (المجموع + زر الإتمام)
  Widget _buildCartSummary(BuildContext context, double totalAmount, List<CartItem> cartItems) {
    if (cartItems.isEmpty) return SizedBox.shrink(); // إخفاء لو كانت فارغة

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // عرض المجموع الكلي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 10),
          // زر الانتقال إلى شاشة إتمام الطلب
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown.shade300,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CheckoutScreen()),
              );
            },
            child: Text(
              'إتمام الطلب',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
