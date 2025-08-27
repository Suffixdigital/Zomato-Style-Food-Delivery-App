import 'package:flutter/material.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/theme/asset_tile_style.dart';
import 'package:smart_flutter/theme/chart_style.dart';
import 'package:smart_flutter/theme/helper.dart';
import 'package:smart_flutter/theme/transaction_tile_style.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  const AppTheme._();

  /// colors and styles
  static AppColors1 get darkColors => const AppColors1(
    brightness: Brightness.dark,
    primary: Color(0xFFFE8C00),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF8859FF),
    onSecondary: Color(0xFFFFFFFF),
    background: Color(0xFF1E1E1E),
    onBackground: Color(0xFF1E1E1E),
    surface: Color(0xFF2C2C2E),
    onSurface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFF406271),
    onSurfaceVariant: Color(0xFFBFCBD0),
    success: Color(0xFF27BA62),
    onSuccess: Color(0xFFFFFFFF),
    error: Color(0xFFF14141),
    onError: Color(0xFFFFFFFF),

    /// Custom colors
    tileBackgroundColor: Color(0xFF002E42),
    generalText: Color(0xFFFFFFFF),
    defaultGray878787: Color(0xFF878787),
    defaultGrayEEEEEE: Color(0xFFEEEEEE),
    defaultWhite: Color(0xFFFFFFFF),
    defaultBlack: Color(0xFF000000),
    defaultDisableColor: Color(0xFF002E42),
    defaultEnableColor: Color(0xFF002E42),

    defaultText: Color(0xFFFFFFFF),
    lightText: Color(0xFFC2C2C2),

    defaultIcon: Color(0xFF1E1E1E),
    disabledIcon: Color(0xFFC2C2C2),
    enabledIcon: Color(0xFFFFFFFF),
    disabledSurface: Color(0xFF8097A0),
    onDisabledSurface: Color(0xFFBFCBD0),
    linearGradient: LinearGradient(
      colors: [Color(0xFF27BA62), Color(0xFF137A61), Color(0xFF0B6060)],
    ),
  );

  static AppColors1 get lightColors => const AppColors1(
    brightness: Brightness.light,
    primary: Color(0xFFFE8C00),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF8859FF),
    onSecondary: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    surfaceVariant: Color(0xFFF2F5F6),
    onSurfaceVariant: Color(0xFF667C86),
    success: Color(0xFF27BA62),
    onSuccess: Color(0xFFFFFFFF),
    error: Color(0xFFF14141),
    onError: Color(0xFFFFFFFF),

    /// Custom colors
    tileBackgroundColor: Color(0xFFF2F5F6),

    generalText: Color(0xFF000000),
    defaultGray878787: Color(0xFF878787),
    defaultGrayEEEEEE: Color(0xFFEEEEEE),
    defaultWhite: Color(0xFFFFFFFF),
    defaultBlack: Color(0xFF000000),
    defaultDisableColor: Color(0xFFC2C2C2),
    defaultEnableColor: Color(0xFFFFFFFF),

    defaultText: Color(0xFF000000),
    lightText: Color(0xFFC2C2C2),

    defaultIcon: Color(0xFFFFFFFF),
    disabledIcon: Color(0xFFC2C2C2),
    enabledIcon: Color(0xFFFFFFFF),
    disabledSurface: Color(0xFFD2DBDE),
    onDisabledSurface: Color(0xFFA0B1B8),
    linearGradient: LinearGradient(
      colors: [Color(0xFF27BA62), Color(0xFF137A61), Color(0xFF0B6060)],
    ),
  );

  static TransactionTileStyle get transactionTileStyleDark =>
      TransactionTileStyle(
        backgroundColor: darkColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static TransactionTileStyle get transactionTileStyleLight =>
      TransactionTileStyle(
        backgroundColor: lightColors.tileBackgroundColor,
        borderRadius: 0,
      );

  static AssetTileStyle get assetTileStyleDark => AssetTileStyle(
    backgroundColor: darkColors.tileBackgroundColor,
    borderRadius: 0,
  );

  static AssetTileStyle get assetTileStyleLight => AssetTileStyle(
    backgroundColor: lightColors.tileBackgroundColor,
    borderRadius: 0,
  );

  static FLChartStyle get chartStyleDark => FLChartStyle(
    backgroundColor: darkColors.surface,
    chartColor1: darkColors.linearGradient.colors[0],
    chartColor2: darkColors.linearGradient.colors[1],
    chartColor3: darkColors.linearGradient.colors[2],
    chartBorderColor: darkColors.surfaceVariant,
    toolTipBgColor: darkColors.onSurfaceVariant,
    isShowingMainData: true,
    animationDuration: const Duration(milliseconds: 100),
    minX: 0,
    maxX: 14,
    maxY: 4,
    minY: 0,
    borderRadius: 12,
  );

  static FLChartStyle get chartStyleLight => FLChartStyle(
    backgroundColor: darkColors.surface,
    chartColor1: darkColors.linearGradient.colors[0],
    chartColor2: darkColors.linearGradient.colors[1],
    chartColor3: darkColors.linearGradient.colors[2],
    chartBorderColor: darkColors.surfaceVariant,
    toolTipBgColor: darkColors.onSurfaceVariant,
    isShowingMainData: false,
    animationDuration: const Duration(milliseconds: 100),
    minX: 0,
    maxX: 14,
    maxY: 4,
    minY: 0,
    borderRadius: 12,
  );

  /// theme
  static ThemeData darkTheme({required bool isTablet}) {
    return ThemeData(
      useMaterial3: true,

      /// COLOR
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: darkColors.brightness,
        primary: darkColors.primary,
        onPrimary: darkColors.onPrimary,
        secondary: darkColors.secondary,
        onSecondary: darkColors.onSecondary,
        error: darkColors.error,
        onError: darkColors.onError,
        surface: darkColors.surface,
        onSurface: darkColors.onSurface,
        surfaceContainerHighest: darkColors.surfaceVariant,
        onSurfaceVariant: darkColors.onSurfaceVariant,
      ),

      scaffoldBackgroundColor: darkColors.background,

      /// TYPOGRAPHY
      textTheme: AppTextTheme1.darkTextTheme,
      iconTheme: IconThemeData(color: darkColors.background),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: darkColors.background,
        foregroundColor: darkColors.onBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextTheme1.labelMedium.copyWith(
            color: darkColors.error,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: darkColors.onSurface),
          foregroundColor: darkColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColors.surface,
        errorStyle: AppTextTheme1.bodySmall.copyWith(color: darkColors.error),
        helperStyle: AppTextTheme1.bodySmall.copyWith(
          color: darkColors.onSurfaceVariant,
        ),
        hintStyle: AppTextTheme1.bodyMedium.copyWith(
          color: darkColors.onSurfaceVariant,
        ),
        focusedErrorBorder: darkColors.error.getOutlineBorder,
        errorBorder: darkColors.error.getOutlineBorder,
        focusedBorder: Colors.transparent.getOutlineBorder,
        iconColor: darkColors.onSurfaceVariant,
        enabledBorder: Colors.transparent.getOutlineBorder,
        disabledBorder: Colors.transparent.getOutlineBorder,
        errorMaxLines: 3,
      ),

      ///Extensions
      extensions: <ThemeExtension>[
        darkColors,
        assetTileStyleDark,
        transactionTileStyleDark,
        chartStyleDark,
        AppTextTheme.fallback(isTablet: isTablet),
      ],
    );
  }

  static ThemeData lightTheme({required bool isTablet}) {
    return ThemeData(
      useMaterial3: true,

      /// COLOR
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: lightColors.brightness,
        primary: lightColors.primary,
        onPrimary: lightColors.onPrimary,
        secondary: lightColors.secondary,
        onSecondary: lightColors.onSecondary,
        error: lightColors.error,
        onError: lightColors.onError,
        surface: lightColors.surface,
        onSurface: lightColors.onSurface,
        surfaceContainerHighest: lightColors.surfaceVariant,
        onSurfaceVariant: lightColors.onSurfaceVariant,
      ),

      scaffoldBackgroundColor: lightColors.background,

      /// TYPOGRAPHY
      textTheme: AppTextTheme1.textTheme,
      iconTheme: IconThemeData(color: lightColors.background),

      /// COMPONENT THEMES
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: lightColors.background,
        foregroundColor: lightColors.onBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextTheme1.labelMedium.copyWith(
            color: lightColors.error,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: lightColors.onSurface),
          foregroundColor: lightColors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColors.surface,
        errorStyle: AppTextTheme1.bodySmall.copyWith(color: lightColors.error),
        helperStyle: AppTextTheme1.bodySmall.copyWith(
          color: lightColors.onSurfaceVariant,
        ),
        hintStyle: AppTextTheme1.bodyMedium.copyWith(
          color: lightColors.onSurfaceVariant,
        ),
        focusedErrorBorder: lightColors.error.getOutlineBorder,
        errorBorder: lightColors.error.getOutlineBorder,
        focusedBorder: Colors.transparent.getOutlineBorder,
        iconColor: lightColors.onSurfaceVariant,
        enabledBorder: Colors.transparent.getOutlineBorder,
        disabledBorder: Colors.transparent.getOutlineBorder,
        errorMaxLines: 3,
      ),

      ///Extensions
      extensions: <ThemeExtension>[
        lightColors,
        assetTileStyleLight,
        transactionTileStyleLight,
        chartStyleLight,
        AppTextTheme.fallback(isTablet: isTablet),
      ],
    );
  }
}
