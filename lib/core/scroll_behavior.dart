import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// سلوك تمرير مخصص يجعل التمرير (Scroll) ناعمًا ويستخدم BouncingScrollPhysics.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        // السماح بالتمرير باستخدام اللمس والفأرة والأجهزة الأخرى
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // إذا أردت تمكين الـBouncing على كل المنصات، استخدم:
    
    
    // أو إذا أردت التفريق بين iOS/Android:
    
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return const BouncingScrollPhysics();
    } else {
      return const ClampingScrollPhysics(); // النمط الافتراضي للأندرويد
    }
    
  }
}
