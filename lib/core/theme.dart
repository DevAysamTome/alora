import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'GDBold',
      
      pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        // لكل منصة (Android, iOS, Web...) يمكنك تحديد Builder
        TargetPlatform.android:  FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS:  CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux:  FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows:  FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS:  CupertinoPageTransitionsBuilder(),
      },
    ),
    );
  }
}