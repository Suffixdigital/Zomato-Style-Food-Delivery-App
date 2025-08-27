import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_flutter/theme/app_colors.dart';

import '../../../core/constants/text_styles.dart';

class ResetPasswordSuccessful extends StatefulWidget {
  final bool isPasswordSet;

  const ResetPasswordSuccessful({super.key, required this.isPasswordSet});

  @override
  State<ResetPasswordSuccessful> createState() => _ResetPasswordSuccessfulState();
}

class _ResetPasswordSuccessfulState extends State<ResetPasswordSuccessful> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Scaffold(
      backgroundColor: context.colors.defaultBlack..withValues(alpha: 0.5),
      // Blurred background illusion
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          decoration: BoxDecoration(color: context.colors.background, borderRadius: BorderRadius.vertical(top: Radius.circular(36.r))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: BoxDecoration(color: context.colors.defaultGray878787, borderRadius: BorderRadius.circular(10.r)),
                ),
              ),

              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Lottie.asset('assets/animation/password_successful.json', width: 250.w, height: 250.h, fit: BoxFit.contain),
              ),

              Center(
                child: Text(
                  widget.isPasswordSet ? "Password Set" : "Password Changed",
                  style: textTheme.headingH5SemiBold!.copyWith(color: context.colors.generalText),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.isPasswordSet ? "Your password has been set successfully." : "Password changed successfully, you can login \nagain with a new password",
                style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.goNamed('login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                  ),
                  child: Text("Log In", style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.defaultWhite)),
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
