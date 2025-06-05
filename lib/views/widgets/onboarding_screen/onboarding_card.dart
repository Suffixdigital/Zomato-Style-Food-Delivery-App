import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/data/page_data.dart';
import 'package:smart_flutter/views/widgets/onboarding_screen/text_button.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_styles.dart';
import 'animated_button.dart';

class OnboardingCard extends StatelessWidget {
  //final Map<String,String> pageDetail;
  // final bool isLast;
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingCard({
    super.key,
    // required this.pageDetail,
    // required this.isLast,
    required this.currentIndex,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    final lastIndex = currentIndex == pages.length - 1;

    return ScreenUtilInit(
      designSize: Size(390, 844), // Base design for responsiveness
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                pages[currentIndex]['image']!,
                fit: BoxFit.cover,
              ),
            ),

            // Foreground Content
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  bottom: isTablet ? 120.h : 70.h,
                  left: 30.w,
                  right: 30.w,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 36.w : 24.w,
                  vertical: isTablet ? 36.h : 24.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent,
                  borderRadius: BorderRadius.circular(52.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pages[currentIndex]['title']!,
                      textAlign: TextAlign.center,
                      // style: AppTextStyles.title(isTablet),
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).headingH4SemiBold!.copyWith(color: AppColors.neutral0),
                    ),
                    SizedBox(height: isTablet ? 32.h : 24.h),

                    Text(
                      pages[currentIndex]['description']!,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumRegular!.copyWith(color: AppColors.neutral0),
                    ),
                    SizedBox(height: isTablet ? 32.h : 20.h),

                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isActive = index == currentIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: isActive ? 40.w : 20.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color:
                                isActive
                                    ? AppColors.neutral0
                                    : AppColors.neutral30,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: isTablet ? 70.h : 40.h),

                    lastIndex
                        ? Center(
                          child: Column(
                            children: [
                              ProgressAnimatedIconButton(onPressed: onNext),
                            ],
                          ),
                        )
                        : SizedBox(
                          height: 100.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextIconButton(
                                textLabel: 'Skip',
                                onPressed: onSkip,
                              ),
                              TextIconButton(
                                textLabel: 'Next',
                                onPressed: onNext,
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
