import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
// استيراد حزمة Font Awesome
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  List<SocialLink> _socialLinks = [];

  @override
  void initState() {
    super.initState();
    _fetchSocialLinks();
  }

  // دالة لجلب روابط التواصل الاجتماعي من Firestore (مثال: مجموعة socialLinks)
  Future<void> _fetchSocialLinks() async {
    try {
      final snap = await FirebaseFirestore.instance.collection("socialLinks").get();

      if (snap.docs.isNotEmpty) {
        final List<SocialLink> links = snap.docs.map((doc) {
          final data = doc.data();
          return SocialLink(
            type: data["type"] ?? "",
            url: data["url"] ?? "",
          );
        }).toList();

        setState(() {
          _socialLinks = links;
        });
      }
    } catch (e) {
      print('خطأ في جلب روابط التواصل: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // تصميم الخلفية والأبعاد
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade200,
      child: Column(
        children: [
          // نص الحقوق
          
          
          // صف الأيقونات
          _buildSocialIconsRow(),
          const SizedBox(height: 8),
          // بإمكانك إضافة أي نصوص أو روابط أخرى
          Text(
            'تابعونا عبر منصات التواصل الاجتماعي',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const Text(
            'جميع الحقوق محفوظة لدى شركة تكنو كور © 2025',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // دالة تبني صف من الأيقونات (Facebook, Instagram, Twitter...) حسب الروابط
  Widget _buildSocialIconsRow() {
    if (_socialLinks.isEmpty) {
      return const SizedBox.shrink(); // إذا لم يوجد روابط، لا نعرض شيئًا
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _socialLinks.map((link) {
        final iconData = _getFontAwesomeIcon(link.type);
        return IconButton(
          icon: FaIcon(iconData, color: Colors.deepOrange),
          onPressed: () => _openUrl(link.url),
        );
      }).toList(),
    );
  }

  // دالة لتحديد الأيقونة من FontAwesome حسب نوع الرابط
  IconData _getFontAwesomeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'facebook':
        return FontAwesomeIcons.facebookF;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      case 'youtube':
        return FontAwesomeIcons.youtube;
      case 'linkedin':
        return FontAwesomeIcons.linkedinIn;
      // أضف غيرها...
      default:
        return FontAwesomeIcons.link; // أيقونة افتراضية
    }
  }

  // فتح الرابط في المتصفح
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      print('لا يمكن فتح الرابط: $url');
    }
  }
}

// نموذج بسيط للرابط
class SocialLink {
  final String type; // "facebook", "instagram", ...
  final String url;

  SocialLink({required this.type, required this.url});
}
