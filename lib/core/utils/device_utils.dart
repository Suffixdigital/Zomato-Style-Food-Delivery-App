import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';

class DeviceUtils {
  // Check if the device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Check if the device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Check if the device is a tablet based on screen width
  static bool isTablet(BuildContext context) {
    double width = getScreenWidth(context);
    return width >= 600.0; // Tablets usually have a width of 600+ px
  }

  // Check if the device is a phone based on screen width
  static bool isPhone(BuildContext context) {
    double width = getScreenWidth(context);
    return width < 600.0; // Phones usually have a width less than 600 px
  }

  // Get device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  // Get text scaling factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  static TextStyle titleStyle = const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle subtitleStyle = const TextStyle(fontSize: 16, color: Colors.grey);

  static RegExp passwordRegex = RegExp(
    r'^(?=.*\d)' // at least one digit
    r'(?=.*[a-z])' // at least one lowercase letter
    r'(?=.*[A-Z])' // at least one uppercase letter
    r'(?=.*[a-zA-Z])' // any letter (redundant, can be removed)
    r'(?=.*[@#$%^&+=])' // at least one special character
    r'(?!.*\s)' // no white spaces
    r'.{8,32}$', // 8 to 32 characters
  );

  static Widget socialIcon(String assetPath, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: iconColor, // border color
          width: 1.w, // border width
        ),
      ),
      child: CircleAvatar(
        radius: 24.r,
        backgroundColor: iconColor,
        //child: Image.asset(assetPath, width: 24.w, height: 24.h),
        child: SvgPicture.asset(assetPath, width: 36.w, height: 36.h),
      ),
    );
  }

  static Widget backIcon(String assetPath, Color iconColor, int size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.neutral40, // border color
          width: 1.w, // border width
        ),
      ),
      child: CircleAvatar(
        radius: size.r,
        backgroundColor: Colors.transparent,
        //child: Image.asset(assetPath, width: 24.w, height: 24.h),
        child: SvgPicture.asset(assetPath, width: size.w, height: size.h, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
      ),
    );
  }

  static Widget homeScreenIcon(String assetPath, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: iconColor, // border color
          width: 1.w, // border width
        ),
      ),
      child: CircleAvatar(
        radius: 16.r,
        backgroundColor: Colors.transparent,
        //child: Image.asset(assetPath, width: 24.w, height: 24.h),
        child: SvgPicture.asset(assetPath, width: 16.w, height: 16.h),
      ),
    );
  }

  static String generateTempPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$%';
    final rand = Random.secure();
    return List.generate(12, (index) => chars[rand.nextInt(chars.length)]).join();
  }
}
