import 'package:flutter/material.dart';
import 'package:smart_flutter/theme/app_theme.dart';

class AppTextTheme1 {
  const AppTextTheme1._();

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppTheme.darkColors.generalText),
    displayMedium: displayMedium.copyWith(
      color: AppTheme.darkColors.generalText,
    ),
    displaySmall: displaySmall.copyWith(color: AppTheme.darkColors.generalText),
    headlineLarge: headlineLarge.copyWith(
      color: AppTheme.darkColors.generalText,
    ),
    headlineMedium: headlineMedium.copyWith(
      color: AppTheme.darkColors.generalText,
    ),
    headlineSmall: headlineSmall.copyWith(
      color: AppTheme.darkColors.generalText,
    ),
    titleLarge: titleLarge.copyWith(color: AppTheme.darkColors.generalText),
    titleMedium: titleMedium.copyWith(color: AppTheme.darkColors.generalText),
    titleSmall: titleSmall.copyWith(color: AppTheme.darkColors.generalText),
    bodyLarge: bodyLarge.copyWith(color: AppTheme.darkColors.generalText),
    bodyMedium: bodyMedium.copyWith(color: AppTheme.darkColors.generalText),
    bodySmall: bodySmall.copyWith(color: AppTheme.darkColors.generalText),
    labelLarge: labelLarge.copyWith(color: AppTheme.darkColors.generalText),
    labelMedium: labelMedium.copyWith(color: AppTheme.darkColors.generalText),
    labelSmall: labelSmall.copyWith(color: AppTheme.darkColors.generalText),
  );

  static TextTheme textTheme = TextTheme(
    displayLarge: displayLarge.copyWith(
      color: AppTheme.lightColors.generalText,
    ),
    displayMedium: displayMedium.copyWith(
      color: AppTheme.lightColors.generalText,
    ),
    displaySmall: displaySmall.copyWith(
      color: AppTheme.lightColors.generalText,
    ),
    headlineLarge: headlineLarge.copyWith(
      color: AppTheme.lightColors.generalText,
    ),
    headlineMedium: headlineMedium.copyWith(
      color: AppTheme.lightColors.generalText,
    ),
    headlineSmall: headlineSmall.copyWith(
      color: AppTheme.lightColors.generalText,
    ),
    titleLarge: titleLarge.copyWith(color: AppTheme.lightColors.generalText),
    titleMedium: titleMedium.copyWith(color: AppTheme.lightColors.generalText),
    titleSmall: titleSmall.copyWith(color: AppTheme.lightColors.generalText),
    bodyLarge: bodyLarge.copyWith(color: AppTheme.lightColors.generalText),
    bodyMedium: bodyMedium.copyWith(color: AppTheme.lightColors.generalText),
    bodySmall: bodySmall.copyWith(color: AppTheme.lightColors.generalText),
    labelLarge: labelLarge.copyWith(color: AppTheme.lightColors.generalText),
    labelMedium: labelMedium.copyWith(color: AppTheme.lightColors.generalText),
    labelSmall: labelSmall.copyWith(color: AppTheme.lightColors.generalText),
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );

  static TextStyle headlineLarge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );
}

extension AppTextThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
