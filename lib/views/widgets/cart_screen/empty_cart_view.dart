import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
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
              style: textTheme.headingH5Bold!.copyWith(
                color: context.colors.generalText,
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44.w),
              child: Text(
                "Seems like you have not ordered any food yet",
                textAlign: TextAlign.center,
                style: textTheme.bodyLargeRegular!.copyWith(
                  color: context.colors.defaultGray878787,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  "Find Foods",
                  style: textTheme.bodyMediumSemiBold!.copyWith(
                    color: context.colors.defaultWhite,
                  ),
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
