import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/screens/email_otp_verification_screen.dart';

import '../core/constants/text_styles.dart';
import '../core/data/contact_details.dart';

class ForgotPasswordContactDetailsScreen extends StatefulWidget {
  const ForgotPasswordContactDetailsScreen({super.key});

  @override
  State<ForgotPasswordContactDetailsScreen> createState() =>
      _ForgotPasswordContactDetailsScreenState();
}

class _ForgotPasswordContactDetailsScreenState
    extends State<ForgotPasswordContactDetailsScreen> {
  int selectedIndex = 0;

  void onOptionTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppColors.neutral100.withValues(alpha: 0.5),
      // Blurred background illusion
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AppColors.neutral0,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.neutral40,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Forgot password?",
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).headingH5SemiBold!.copyWith(color: AppColors.neutral100),
              ),
              SizedBox(height: 8.h),
              Text(
                "Select which contact details should we use to reset your password",
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
              ),
              SizedBox(height: 24.h),

              // Options
              ...List.generate(contactDetails.length, (index) {
                final isSelected = selectedIndex == index;
                final option = contactDetails[index];

                return GestureDetector(
                  onTap: () => onOptionTap(index),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryAccent
                                : AppColors.neutral30,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      color:
                          isSelected
                              ? AppColors.primaryAccent.withValues(alpha: 0.04)
                              : AppColors.neutral0,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.neutral30,
                          radius: 24.r,
                          child: option['icon'],
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['label'],
                                style: AppTextTheme.fallback(isTablet: isTablet)
                                    .bodySmallRegular!
                                    .copyWith(color: AppColors.neutral60),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                option['value'],
                                style: AppTextTheme.fallback(isTablet: isTablet)
                                    .bodyMediumSemiBold!
                                    .copyWith(color: AppColors.neutral100),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primaryAccent,
                            size: 24.sp,
                          ),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailOtpVerificationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: AppTextTheme.fallback(
                      isTablet: isTablet,
                    ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral0),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
