import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool obscureText;

  final bool readOnly;
  final TextInputType keyboardType;
  final VoidCallback? onVisibilityTap;
  final VoidCallback onTap;

  final ValueChanged<String>? onChanged;

  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.obscureText = false,
    this.readOnly = false,
    required this.onTap,
    required this.keyboardType,
    this.onVisibilityTap,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;

    return TextField(
      controller: controller,
      obscureText: isPassword && obscureText,
      keyboardType: keyboardType,
      cursorColor: AppColors.primaryAccent,
      obscuringCharacter: "*",
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextTheme.fallback(
          isTablet: isTablet,
        ).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
        filled: true,
        fillColor: AppColors.neutral0,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.neutral30, width: 1.2.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.neutral30, width: 1.2.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.neutral50, width: 1.2.w),
        ),
        errorText: errorText,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red, width: 1.2.w),
        ),
        errorStyle: AppTextTheme.fallback(
          isTablet: isTablet,
        ).bodyMediumMedium!.copyWith(color: Colors.red),
        errorMaxLines: 4,
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.neutral100,
                  ),
                  onPressed: onVisibilityTap,
                )
                : null,
      ),
    );
  }
}
