import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  AppColors._();

  static const Color ink = Color(0xFF2D1B1E);
  static const Color paper = Color(0xFFFFF8F7);
  static const Color surface = Colors.white;
  static const Color sand = Color(0xFFF2E3E1);
  static const Color line = Color(0xFFE8D3D0);
  static const Color muted = Color(0xFF7A6B6E);
  static const Color subtle = Color(0xFF9E8E92);
  static const Color success = Color(0xFF0EA5A4);
  static const Color danger = Color(0xFFE11D48);
  static const Color warning = Color(0xFFD97706);
}

class AppTheme {
  AppTheme._();

  static ThemeData build(Color primary) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: AppColors.surface,
      brightness: Brightness.light,
    ).copyWith(onPrimary: _onColor(primary));

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Plex',
      scaffoldBackgroundColor: AppColors.paper,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      // 1.sp = مقياس الخط المحدود من Responsive.fontSize (للنصوص بلا حجم صريح).
      // نبدأ من أحجام Material للعربية (tall2021) لأن base.textTheme بلا أحجام بعد.
      textTheme: Typography.tall2021
          .merge(base.textTheme)
          .apply(
            bodyColor: AppColors.ink,
            displayColor: AppColors.ink,
            fontSizeFactor: 1.sp,
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Plex',
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: AppColors.subtle, fontSize: 14.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: _onColor(primary),
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            fontFamily: 'Plex',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            fontFamily: 'Plex',
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.line),
        labelStyle: const TextStyle(
          fontFamily: 'Plex',
          fontWeight: FontWeight.w600,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: const TextStyle(
          fontFamily: 'Plex',
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// نص أسود أو أبيض حسب سطوع اللون.
  static Color _onColor(Color c) =>
      c.computeLuminance() > 0.5 ? AppColors.ink : Colors.white;
}
