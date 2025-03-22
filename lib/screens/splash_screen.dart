import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // انتظر 3 ثوانٍ ثم انتقل للشاشة المطلوبة
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login'); 
      // أو '/home' إذا أردت الذهاب مباشرةً للواجهة الرئيسية
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // يمكنك اختيار لون خلفية يناسب هوية تطبيقك
      backgroundColor: Colors.brown.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار التطبيق
            Image.asset(
              'assets/alora_logo.png', // ضع مسار الشعار هنا
              width: 120,                   // يمكنك تعديل الحجم
              height: 120,
            ),
            const SizedBox(height: 16),
            // نص اختياري تحت الشعار (اسم التطبيق أو عبارة ترحيبية)
            const Text(
              'A L O R A',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50,),
                 Text(
              'جميع الحقوق محفوظة لدى شركة تكنو كور © 2025',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
