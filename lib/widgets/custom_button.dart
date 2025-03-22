import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.deepOrange.shade300,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.shifting,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'السلة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'استكشف',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'المفضلة',
        ),
               BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'التصنيفات',
        ),
       
      ],
    );
  }
}
