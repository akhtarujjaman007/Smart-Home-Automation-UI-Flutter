import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Colors.blueAccent;

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final tt = base.textTheme;

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(primary: primary),
      scaffoldBackgroundColor: const Color(0xFFF4F6F6),
      textTheme: tt.copyWith(
        headlineSmall: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        titleLarge: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        titleMedium: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final tt = base.textTheme;

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(primary: primary),
      scaffoldBackgroundColor: const Color(0xFF0F1012),
      textTheme: tt.copyWith(
        headlineSmall: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        titleLarge: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        titleMedium: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
