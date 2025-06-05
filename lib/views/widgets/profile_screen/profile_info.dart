import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';

class ProfileInfo extends StatelessWidget {
  final bool isTablet = false;

  const ProfileInfo({super.key, required bool isTablet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 45.r,
              child: Image.asset("assets/images/profile.png"),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.w),
                ),
                padding: EdgeInsets.all(5.sp),
                child: Icon(Icons.camera_alt, size: 16.sp, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          'Kirtikant Patadiya',
          style: AppTextTheme.fallback(
            isTablet: isTablet,
          ).bodyLargeSemiBold!.copyWith(color: AppColors.neutral100),
        ),
        Text(
          'kirtikantpatadiya@gmail.com',
          style: AppTextTheme.fallback(
            isTablet: isTablet,
          ).bodyMediumRegular!.copyWith(color: AppColors.neutral60),
        ),
      ],
    );
  }
}
