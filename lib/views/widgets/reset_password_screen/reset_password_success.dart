import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_flutter/screens/login_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_styles.dart';

class ResetPasswordSuccessful extends StatefulWidget {
  const ResetPasswordSuccessful({super.key});

  @override
  State<ResetPasswordSuccessful> createState() =>
      _ResetPasswordSuccessfulState();
}

class _ResetPasswordSuccessfulState extends State<ResetPasswordSuccessful> {
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

              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Lottie.asset(
                  'assets/animation/password_successful.json',
                  width: 250.w,
                  height: 250.h,
                  fit: BoxFit.contain,
                ),
              ),

              Center(
                child: Text(
                  "Password Changed",
                  style: AppTextTheme.fallback(
                    isTablet: isTablet,
                  ).headingH5SemiBold!.copyWith(color: AppColors.neutral100),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Password changed successfully, you can login \nagain with a new password",
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => LoginScreen(
                              shouldForgotPasswordModelOnLoad: false,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Log In",
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
