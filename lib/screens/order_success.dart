import 'package:flutter/material.dart';
import 'package:aloraapp/screens/home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // نجعل خلفية الشاشة تمتد خلف أي عنصر
        extendBodyBehindAppBar: true,
        // شريط علوي شفاف
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // إن أردت إخفاء شريط التطبيق تمامًا، يمكنك إزالة الـAppBar
        ),
        body: Container(
          // خلفية متدرجة
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.brown.shade300,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                // ابدأ المحتوى أسفل شريط التطبيق الشفاف
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // أيقونة نجاح كبيرة
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    padding: EdgeInsets.all(24),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                  ),
                  SizedBox(height: 20),
      
                  // عنوان النجاح
                  Text(
                    'تم تقديم طلبك بنجاح!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
      
                  // نص توضيحي قصير (اختياري)
                  Text(
                    'شكراً لاختيارك متجرنا. سيتم التواصل معك قريباً بخصوص تفاصيل الطلب.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
      
                  // زر العودة للصفحة الرئيسية
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        'العودة للصفحة الرئيسية',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
}
