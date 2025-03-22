import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "السلة"),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: "التصنيفات"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "الحساب"),
      ],
    );
  }
}
