import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aloraapp/providers/favorites_provider.dart';
import 'package:aloraapp/screens/product_details.dart';
import 'package:aloraapp/utils/product_card_widget.dart';
import '../data/models/product.dart';

class ProductCardWithButtons extends StatelessWidget {
  final Product product;

  const ProductCardWithButtons({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // البطاقة من المكتبة
       ProductCard(
          productName: product.name,
          price: product.price,
          isAvailable: product.isAvailable,
          rating: 4.5,
          discountPercentage: product.discount.toDouble(),
          quantity: product.quantity,
          categoryName: product.category,
          imageUrl: product.imageUrl,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
            );
          },
          onFavoritePressed: () {
              Provider.of<FavoritesProvider>(context, listen: false).addToFavorites(product);
 ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت إضافة المنتج إلى المفضلة')));
          },
        ),
        // الأزرار المخصصة
        
      ],
    );
  }
}
