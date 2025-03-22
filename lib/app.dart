import 'package:flutter/material.dart';
import 'package:aloraapp/screens/cart_screen.dart';
import 'package:aloraapp/screens/explore_screen.dart';
import 'package:aloraapp/screens/home_screen.dart';

class MainWrapper extends StatefulWidget {
  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // الصفحات (التبويبات) التي ستظهر في IndexedStack
  final List<Widget> _screens = [
    HomeScreen(),      // التبويب الأول
    CartScreen(),   // التبويب الثاني
    ExploreScreen(), // التبويب الثالث
      // التبويب الخامس
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack تتيح عرض شاشة واحدة فقط في كل مرة
      // لكنها تبقي الشاشات الأخرى محفوظة في الذاكرة (لا تعيد البناء عند الانتقال)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // شريط التنقل السفلي
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'السلة'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'استكشاف'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'مفضلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
