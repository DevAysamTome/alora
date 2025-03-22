import 'package:flutter/material.dart';
import 'package:aloraapp/data/models/brand.dart';

class BrandItem extends StatelessWidget {
  final Brand brand;
  final VoidCallback onTap;

  const BrandItem({Key? key, required this.brand, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // عند الضغط
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(brand.logo),
            ),
            SizedBox(height: 4),
            Text(
              brand.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
