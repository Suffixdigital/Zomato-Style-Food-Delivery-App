import 'package:flutter/material.dart';

@immutable
class AppColors1 extends ThemeExtension<AppColors1> {
  const AppColors1({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.error,
    required this.onError,
    required this.success,
    required this.onSuccess,

    /// Custom colors
    required this.tileBackgroundColor,
    required this.generalText,
    required this.defaultGray878787,
    required this.defaultGrayEEEEEE,
    required this.defaultWhite,
    required this.defaultBlack,
    required this.defaultDisableColor,
    required this.defaultEnableColor,
    required this.defaultText,
    required this.lightText,
    required this.defaultIcon,
    required this.disabledIcon,
    required this.enabledIcon,
    required this.disabledSurface,
    required this.onDisabledSurface,
    required this.linearGradient,
  });

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color error;
  final Color onError;
  final Color success;
  final Color onSuccess;

  /// Custom colors
  final Color tileBackgroundColor;
  final Color generalText;
  final Color defaultGray878787;
  final Color defaultGrayEEEEEE;
  final Color defaultWhite;
  final Color defaultBlack;
  final Color defaultDisableColor;
  final Color defaultEnableColor;

  final Color defaultText;
  final Color lightText;
  final Color defaultIcon;
  final Color disabledIcon;
  final Color enabledIcon;
  final Color disabledSurface;
  final Color onDisabledSurface;
  final LinearGradient linearGradient;

  @override
  ThemeExtension<AppColors1> copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? error,
    Color? onError,
    Color? success,
    Color? onSuccess,

    /// Custom colors
    Color? tileBackgroundColor,
    Color? generalText,
    Color? defaultGray878787,
    Color? defaultGrayEEEEEE,
    Color? defaultWhite,
    Color? defaultBlack,
    Color? defaultDisableColor,
    Color? defaultEnableColor,
    Color? defaultText,
    Color? lightText,
    Color? defaultIcon,
    Color? disabledIcon,
    Color? enabledIcon,
    Color? disabledSurface,
    Color? onDisabledSurface,
    LinearGradient? linearGradient,
  }) {
    return AppColors1(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,

      /// Custom colors
      tileBackgroundColor: tileBackgroundColor ?? this.tileBackgroundColor,
      generalText: generalText ?? this.generalText,
      defaultGray878787: defaultGray878787 ?? this.defaultGray878787,
      defaultGrayEEEEEE: defaultGrayEEEEEE ?? this.defaultGrayEEEEEE,
      defaultWhite: defaultWhite ?? this.defaultWhite,
      defaultBlack: defaultBlack ?? this.defaultBlack,
      defaultDisableColor: defaultDisableColor ?? this.defaultDisableColor,
      defaultEnableColor: defaultEnableColor ?? this.defaultEnableColor,
      defaultText: defaultText ?? this.defaultText,
      lightText: lightText ?? this.lightText,
      defaultIcon: defaultIcon ?? this.defaultIcon,
      disabledIcon: disabledIcon ?? this.disabledIcon,
      enabledIcon: enabledIcon ?? this.enabledIcon,
      disabledSurface: disabledSurface ?? this.disabledSurface,
      onDisabledSurface: onDisabledSurface ?? this.onDisabledSurface,
      linearGradient: linearGradient ?? this.linearGradient,
    );
  }

  @override
  ThemeExtension<AppColors1> lerp(ThemeExtension<AppColors1>? other, double t) {
    if (other is! AppColors1) {
      return this;
    }

    return AppColors1(
      brightness: brightness,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? onPrimary,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t) ?? onSecondary,
      background: Color.lerp(background, other.background, t) ?? background,
      onBackground:
          Color.lerp(onBackground, other.onBackground, t) ?? onBackground,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      surfaceVariant:
          Color.lerp(surfaceVariant, other.surfaceVariant, t) ?? surfaceVariant,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t) ??
          onSurfaceVariant,
      error: Color.lerp(error, other.error, t) ?? error,
      onError: Color.lerp(onError, other.onError, t) ?? onError,
      success: Color.lerp(success, other.success, t) ?? success,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t) ?? onSuccess,

      /// Custom colors
      tileBackgroundColor:
          Color.lerp(tileBackgroundColor, other.tileBackgroundColor, t) ??
          tileBackgroundColor,
      generalText: Color.lerp(generalText, other.generalText, t) ?? generalText,
      defaultGray878787:
          Color.lerp(defaultGray878787, other.defaultGray878787, t) ??
          defaultGray878787,
      defaultGrayEEEEEE:
          Color.lerp(defaultGrayEEEEEE, other.defaultGrayEEEEEE, t) ??
          defaultGrayEEEEEE,
      defaultWhite:
          Color.lerp(defaultWhite, other.defaultWhite, t) ?? defaultWhite,
      defaultBlack:
          Color.lerp(defaultBlack, other.defaultBlack, t) ?? defaultBlack,
      defaultDisableColor:
          Color.lerp(defaultDisableColor, other.defaultDisableColor, t) ??
          defaultDisableColor,
      defaultEnableColor:
          Color.lerp(defaultEnableColor, other.defaultEnableColor, t) ??
          defaultEnableColor,
      defaultText: Color.lerp(defaultText, other.defaultText, t) ?? defaultText,
      lightText: Color.lerp(lightText, other.lightText, t) ?? lightText,
      defaultIcon: Color.lerp(defaultIcon, other.defaultIcon, t) ?? defaultIcon,
      disabledIcon:
          Color.lerp(disabledIcon, other.disabledIcon, t) ?? disabledIcon,
      enabledIcon: Color.lerp(enabledIcon, other.enabledIcon, t) ?? enabledIcon,
      disabledSurface:
          Color.lerp(disabledSurface, other.disabledSurface, t) ??
          disabledSurface,
      onDisabledSurface:
          Color.lerp(onDisabledSurface, other.onDisabledSurface, t) ??
          onDisabledSurface,
      linearGradient:
          LinearGradient.lerp(linearGradient, other.linearGradient, t) ??
          linearGradient,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors1 get colors => Theme.of(this).extension<AppColors1>()!;
}
