import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Title text style
  static TextStyle title(bool isTablet) => TextStyle(
    fontSize: isTablet ? 50.sp : 36.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.neutral0,
    wordSpacing: 2.5,
    letterSpacing: 1.5,
    height: 1.0,
  );

  // Subtitle text style
  static TextStyle subtitle(bool isTablet) => TextStyle(
    fontSize: isTablet ? 24.sp : 16.sp,
    color: AppColors.neutral0,
    height: 1.2,
  );

  // Button text style
  static TextStyle buttonText(bool isTablet) => TextStyle(
    color: AppColors.neutral0,
    fontSize: isTablet ? 24.sp : 18.sp,
    fontWeight: FontWeight.w700,
  );

  // General body text
  static TextStyle body(bool isTablet) => TextStyle(
    fontSize: isTablet ? 20.sp : 14.sp,
    color: AppColors.neutral700,
    height: 1.4,
  );

  // Caption or helper text
  static TextStyle caption(bool isTablet) => TextStyle(
    fontSize: isTablet ? 16.sp : 12.sp,
    color: AppColors.neutral500,
  );
}

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  final TextStyle? headingH1Bold;
  final TextStyle? headingH1SemiBold;
  final TextStyle? headingH1Medium;
  final TextStyle? headingH1Regular;
  final TextStyle? headingH2Bold;
  final TextStyle? headingH2SemiBold;
  final TextStyle? headingH2Medium;
  final TextStyle? headingH2Regular;
  final TextStyle? headingH3Bold;
  final TextStyle? headingH3SemiBold;
  final TextStyle? headingH3Medium;
  final TextStyle? headingH3Regular;
  final TextStyle? headingH4Bold;
  final TextStyle? headingH4SemiBold;
  final TextStyle? headingH4Medium;
  final TextStyle? headingH4Regular;
  final TextStyle? headingH5Bold;
  final TextStyle? headingH5SemiBold;
  final TextStyle? headingH5Medium;
  final TextStyle? headingH5Regular;
  final TextStyle? headingH6Bold;
  final TextStyle? headingH6SemiBold;
  final TextStyle? headingH6Medium;
  final TextStyle? headingH6Regular;
  final TextStyle? bodyLargeBold;
  final TextStyle? bodyLargeSemiBold;
  final TextStyle? bodyLargeMedium;
  final TextStyle? bodyLargeRegular;
  final TextStyle? bodyMediumBold;
  final TextStyle? bodyMediumSemiBold;
  final TextStyle? bodyMediumMedium;
  final TextStyle? bodyMediumRegular;
  final TextStyle? bodySmallBold;
  final TextStyle? bodySmallSemiBold;
  final TextStyle? bodySmallMedium;
  final TextStyle? bodySmallRegular;
  final TextStyle? bodySuperSmallBold;
  final TextStyle? bodySuperSmallSemiBold;
  final TextStyle? bodySuperSmallMedium;
  final TextStyle? bodySuperSmallRegular;

  const AppTextTheme({
    this.headingH1Bold,
    this.headingH1SemiBold,
    this.headingH1Medium,
    this.headingH1Regular,
    this.headingH2Bold,
    this.headingH2SemiBold,
    this.headingH2Medium,
    this.headingH2Regular,
    this.headingH3Bold,
    this.headingH3SemiBold,
    this.headingH3Medium,
    this.headingH3Regular,
    this.headingH4Bold,
    this.headingH4SemiBold,
    this.headingH4Medium,
    this.headingH4Regular,
    this.headingH5Bold,
    this.headingH5SemiBold,
    this.headingH5Medium,
    this.headingH5Regular,
    this.headingH6Bold,
    this.headingH6SemiBold,
    this.headingH6Medium,
    this.headingH6Regular,
    this.bodyLargeBold,
    this.bodyLargeSemiBold,
    this.bodyLargeMedium,
    this.bodyLargeRegular,
    this.bodyMediumBold,
    this.bodyMediumSemiBold,
    this.bodyMediumMedium,
    this.bodyMediumRegular,
    this.bodySmallBold,
    this.bodySmallSemiBold,
    this.bodySmallMedium,
    this.bodySmallRegular,
    this.bodySuperSmallBold,
    this.bodySuperSmallSemiBold,
    this.bodySuperSmallMedium,
    this.bodySuperSmallRegular,
  });

  factory AppTextTheme.fallback({required bool isTablet}) => AppTextTheme(
    headingH1Bold: const TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.13,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH1SemiBold: const TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.13,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH1Medium: const TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.13,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH1Regular: const TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH2Bold: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.17,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH2SemiBold: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.17,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH2Medium: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.17,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH2Regular: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.17,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH3Bold: const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.2,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH3SemiBold: TextStyle(
      fontSize: isTablet ? 52.sp : 40.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.2,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH3Medium: const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.2,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH3Regular: const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.2,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH4Bold: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.25,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH4SemiBold: TextStyle(
      fontSize: isTablet ? 48.sp : 34.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.25,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH4Medium: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.25,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH4Regular: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.25,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH5Bold: TextStyle(
      fontSize: isTablet ? 36.sp : 24.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.33,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH5SemiBold: TextStyle(
      fontSize: isTablet ? 36.sp : 24.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.33,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH5Medium: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.33,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH5Regular: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.33,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH6Bold: TextStyle(
      fontSize: isTablet ? 18.sp : 22.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.44,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH6SemiBold: TextStyle(
      fontSize: isTablet ? 26.sp : 18.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.44,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH6Medium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.44,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    headingH6Regular: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.44,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodyLargeBold: TextStyle(
      fontSize: isTablet ? 22.sp : 16.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.5,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodyLargeSemiBold: TextStyle(
      fontSize: isTablet ? 22.sp : 16.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.5,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodyLargeMedium: TextStyle(
      fontSize: isTablet ? 22.sp : 14.sp,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.5,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodyLargeRegular: TextStyle(
      fontSize: isTablet ? 22.sp : 16.sp,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.5,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodyMediumBold: TextStyle(
      fontSize: isTablet ? 18.sp : 14.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.43,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodyMediumSemiBold: TextStyle(
      fontSize: isTablet ? 18.sp : 14.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.43,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodyMediumMedium: TextStyle(
      fontSize: isTablet ? 18.sp : 14.sp,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.43,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodyMediumRegular: TextStyle(
      fontSize: isTablet ? 18.sp : 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.43,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodySmallBold: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.33,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodySmallSemiBold: TextStyle(
      fontSize: isTablet ? 14.sp : 12.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.33,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodySmallMedium: TextStyle(
      fontSize: isTablet ? 14.sp : 12.sp,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.33,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodySmallRegular: TextStyle(
      fontSize: isTablet ? 15.sp : 12.sp,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.33,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodySuperSmallBold: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.6,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodySuperSmallSemiBold: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      fontFamily: "Inter",
      height: 1.6,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodySuperSmallMedium: TextStyle(
      fontSize: isTablet ? 12.sp : 10.sp,
      fontWeight: FontWeight.w500,
      fontFamily: "Inter",
      height: 1.6,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
    bodySuperSmallRegular: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      fontFamily: "Inter",
      height: 1.6,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    ),
  );

  @override
  AppTextTheme copyWith({
    TextStyle? headingH1Bold,
    TextStyle? headingH1SemiBold,
    TextStyle? headingH1Medium,
    TextStyle? headingH1Regular,
    TextStyle? headingH2Bold,
    TextStyle? headingH2SemiBold,
    TextStyle? headingH2Medium,
    TextStyle? headingH2Regular,
    TextStyle? headingH3Bold,
    TextStyle? headingH3SemiBold,
    TextStyle? headingH3Medium,
    TextStyle? headingH3Regular,
    TextStyle? headingH4Bold,
    TextStyle? headingH4SemiBold,
    TextStyle? headingH4Medium,
    TextStyle? headingH4Regular,
    TextStyle? headingH5Bold,
    TextStyle? headingH5SemiBold,
    TextStyle? headingH5Medium,
    TextStyle? headingH5Regular,
    TextStyle? headingH6Bold,
    TextStyle? headingH6SemiBold,
    TextStyle? headingH6Medium,
    TextStyle? headingH6Regular,
    TextStyle? bodyLargeBold,
    TextStyle? bodyLargeSemiBold,
    TextStyle? bodyLargeMedium,
    TextStyle? bodyLargeRegular,
    TextStyle? bodyMediumBold,
    TextStyle? bodyMediumSemiBold,
    TextStyle? bodyMediumMedium,
    TextStyle? bodyMediumRegular,
    TextStyle? bodySmallBold,
    TextStyle? bodySmallSemiBold,
    TextStyle? bodySmallMedium,
    TextStyle? bodySmallRegular,
    TextStyle? bodySuperSmallBold,
    TextStyle? bodySuperSmallSemiBold,
    TextStyle? bodySuperSmallMedium,
    TextStyle? bodySuperSmallRegular,
  }) {
    return AppTextTheme(
      headingH1Bold: headingH1Bold ?? this.headingH1Bold,
      headingH1SemiBold: headingH1SemiBold ?? this.headingH1SemiBold,
      headingH1Medium: headingH1Medium ?? this.headingH1Medium,
      headingH1Regular: headingH1Regular ?? this.headingH1Regular,
      headingH2Bold: headingH2Bold ?? this.headingH2Bold,
      headingH2SemiBold: headingH2SemiBold ?? this.headingH2SemiBold,
      headingH2Medium: headingH2Medium ?? this.headingH2Medium,
      headingH2Regular: headingH2Regular ?? this.headingH2Regular,
      headingH3Bold: headingH3Bold ?? this.headingH3Bold,
      headingH3SemiBold: headingH3SemiBold ?? this.headingH3SemiBold,
      headingH3Medium: headingH3Medium ?? this.headingH3Medium,
      headingH3Regular: headingH3Regular ?? this.headingH3Regular,
      headingH4Bold: headingH4Bold ?? this.headingH4Bold,
      headingH4SemiBold: headingH4SemiBold ?? this.headingH4SemiBold,
      headingH4Medium: headingH4Medium ?? this.headingH4Medium,
      headingH4Regular: headingH4Regular ?? this.headingH4Regular,
      headingH5Bold: headingH5Bold ?? this.headingH5Bold,
      headingH5SemiBold: headingH5SemiBold ?? this.headingH5SemiBold,
      headingH5Medium: headingH5Medium ?? this.headingH5Medium,
      headingH5Regular: headingH5Regular ?? this.headingH5Regular,
      headingH6Bold: headingH6Bold ?? this.headingH6Bold,
      headingH6SemiBold: headingH6SemiBold ?? this.headingH6SemiBold,
      headingH6Medium: headingH6Medium ?? this.headingH6Medium,
      headingH6Regular: headingH6Regular ?? this.headingH6Regular,
      bodyLargeBold: bodyLargeBold ?? this.bodyLargeBold,
      bodyLargeSemiBold: bodyLargeSemiBold ?? this.bodyLargeSemiBold,
      bodyLargeMedium: bodyLargeMedium ?? this.bodyLargeMedium,
      bodyLargeRegular: bodyLargeRegular ?? this.bodyLargeRegular,
      bodyMediumBold: bodyMediumBold ?? this.bodyMediumBold,
      bodyMediumSemiBold: bodyMediumSemiBold ?? this.bodyMediumSemiBold,
      bodyMediumMedium: bodyMediumMedium ?? this.bodyMediumMedium,
      bodyMediumRegular: bodyMediumRegular ?? this.bodyMediumRegular,
      bodySmallBold: bodySmallBold ?? this.bodySmallBold,
      bodySmallSemiBold: bodySmallSemiBold ?? this.bodySmallSemiBold,
      bodySmallMedium: bodySmallMedium ?? this.bodySmallMedium,
      bodySmallRegular: bodySmallRegular ?? this.bodySmallRegular,
      bodySuperSmallBold: bodySuperSmallBold ?? this.bodySuperSmallBold,
      bodySuperSmallSemiBold:
          bodySuperSmallSemiBold ?? this.bodySuperSmallSemiBold,
      bodySuperSmallMedium: bodySuperSmallMedium ?? this.bodySuperSmallMedium,
      bodySuperSmallRegular:
          bodySuperSmallRegular ?? this.bodySuperSmallRegular,
    );
  }

  @override
  AppTextTheme lerp(AppTextTheme? other, double t) {
    if (other is! AppTextTheme) return this;
    return AppTextTheme(
      headingH1Bold: TextStyle.lerp(headingH1Bold, other.headingH1Bold, t),
      headingH1SemiBold: TextStyle.lerp(
        headingH1SemiBold,
        other.headingH1SemiBold,
        t,
      ),
      headingH1Medium: TextStyle.lerp(
        headingH1Medium,
        other.headingH1Medium,
        t,
      ),
      headingH1Regular: TextStyle.lerp(
        headingH1Regular,
        other.headingH1Regular,
        t,
      ),
      headingH2Bold: TextStyle.lerp(headingH2Bold, other.headingH2Bold, t),
      headingH2SemiBold: TextStyle.lerp(
        headingH2SemiBold,
        other.headingH2SemiBold,
        t,
      ),
      headingH2Medium: TextStyle.lerp(
        headingH2Medium,
        other.headingH2Medium,
        t,
      ),
      headingH2Regular: TextStyle.lerp(
        headingH2Regular,
        other.headingH2Regular,
        t,
      ),
      headingH3Bold: TextStyle.lerp(headingH3Bold, other.headingH3Bold, t),
      headingH3SemiBold: TextStyle.lerp(
        headingH3SemiBold,
        other.headingH3SemiBold,
        t,
      ),
      headingH3Medium: TextStyle.lerp(
        headingH3Medium,
        other.headingH3Medium,
        t,
      ),
      headingH3Regular: TextStyle.lerp(
        headingH3Regular,
        other.headingH3Regular,
        t,
      ),
      headingH4Bold: TextStyle.lerp(headingH4Bold, other.headingH4Bold, t),
      headingH4SemiBold: TextStyle.lerp(
        headingH4SemiBold,
        other.headingH4SemiBold,
        t,
      ),
      headingH4Medium: TextStyle.lerp(
        headingH4Medium,
        other.headingH4Medium,
        t,
      ),
      headingH4Regular: TextStyle.lerp(
        headingH4Regular,
        other.headingH4Regular,
        t,
      ),
      headingH5Bold: TextStyle.lerp(headingH5Bold, other.headingH5Bold, t),
      headingH5SemiBold: TextStyle.lerp(
        headingH5SemiBold,
        other.headingH5SemiBold,
        t,
      ),
      headingH5Medium: TextStyle.lerp(
        headingH5Medium,
        other.headingH5Medium,
        t,
      ),
      headingH5Regular: TextStyle.lerp(
        headingH5Regular,
        other.headingH5Regular,
        t,
      ),
      headingH6Bold: TextStyle.lerp(headingH6Bold, other.headingH6Bold, t),
      headingH6SemiBold: TextStyle.lerp(
        headingH6SemiBold,
        other.headingH6SemiBold,
        t,
      ),
      headingH6Medium: TextStyle.lerp(
        headingH6Medium,
        other.headingH6Medium,
        t,
      ),
      headingH6Regular: TextStyle.lerp(
        headingH6Regular,
        other.headingH6Regular,
        t,
      ),
      bodyLargeBold: TextStyle.lerp(bodyLargeBold, other.bodyLargeBold, t),
      bodyLargeSemiBold: TextStyle.lerp(
        bodyLargeSemiBold,
        other.bodyLargeSemiBold,
        t,
      ),
      bodyLargeMedium: TextStyle.lerp(
        bodyLargeMedium,
        other.bodyLargeMedium,
        t,
      ),
      bodyLargeRegular: TextStyle.lerp(
        bodyLargeRegular,
        other.bodyLargeRegular,
        t,
      ),
      bodyMediumBold: TextStyle.lerp(bodyMediumBold, other.bodyMediumBold, t),
      bodyMediumSemiBold: TextStyle.lerp(
        bodyMediumSemiBold,
        other.bodyMediumSemiBold,
        t,
      ),
      bodyMediumMedium: TextStyle.lerp(
        bodyMediumMedium,
        other.bodyMediumMedium,
        t,
      ),
      bodyMediumRegular: TextStyle.lerp(
        bodyMediumRegular,
        other.bodyMediumRegular,
        t,
      ),
      bodySmallBold: TextStyle.lerp(bodySmallBold, other.bodySmallBold, t),
      bodySmallSemiBold: TextStyle.lerp(
        bodySmallSemiBold,
        other.bodySmallSemiBold,
        t,
      ),
      bodySmallMedium: TextStyle.lerp(
        bodySmallMedium,
        other.bodySmallMedium,
        t,
      ),
      bodySmallRegular: TextStyle.lerp(
        bodySmallRegular,
        other.bodySmallRegular,
        t,
      ),
      bodySuperSmallBold: TextStyle.lerp(
        bodySuperSmallBold,
        other.bodySuperSmallBold,
        t,
      ),
      bodySuperSmallSemiBold: TextStyle.lerp(
        bodySuperSmallSemiBold,
        other.bodySuperSmallSemiBold,
        t,
      ),
      bodySuperSmallMedium: TextStyle.lerp(
        bodySuperSmallMedium,
        other.bodySuperSmallMedium,
        t,
      ),
      bodySuperSmallRegular: TextStyle.lerp(
        bodySuperSmallRegular,
        other.bodySuperSmallRegular,
        t,
      ),
    );
  }
}
