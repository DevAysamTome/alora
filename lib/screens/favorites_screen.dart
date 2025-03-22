import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../data/models/product.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites; // قائمة المنتجات المفضلة

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
                        extendBodyBehindAppBar: true,

        appBar: AppBar(
          title: Text('المفضلة',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
        ),
        body: favorites.isEmpty
            ? Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
              child: Center(
                  child: Text('لا توجد عناصر في المفضلة حالياً'),
                ),
            )
            : Container( decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
              child: Padding(
              padding: EdgeInsets.only(top: kToolbarHeight + 16),
                child: ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (ctx, index) {
                      final product = favorites[index];
                      return ListTile(
                        leading: Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Text('${product.price}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            favoritesProvider.removeFromFavorites(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تمت إزالة المنتج من المفضلة')),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ),
            ),
      ),
    );
  }
}
