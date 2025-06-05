import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';

class EmptyCartView extends StatelessWidget {
  final bool isTablet;

  const EmptyCartView({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/empty_cart.svg",
              width: 200.w,
              height: 200.h,
            ),
            SizedBox(height: 30.h),
            Text(
              "Ouch! Hungry",
              style: AppTextTheme.fallback(
                isTablet: isTablet,
              ).headingH5Bold!.copyWith(color: AppColors.neutral100),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44.w),
              child: Text(
                "Seems like you have not ordered any food yet",
                textAlign: TextAlign.center,
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyLargeRegular!.copyWith(color: AppColors.neutral60),
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  "Find Foods",
                  style: AppTextTheme.fallback(
                    isTablet: isTablet,
                  ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral0),
                ),
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
