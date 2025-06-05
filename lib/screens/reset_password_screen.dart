import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_text_field.dart';
import 'package:smart_flutter/views/widgets/reset_password_screen/reset_password_success.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/text_styles.dart';
import '../core/utils/device_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? newPasswordErrorMessage, confirmPasswordErrorMessage;
  bool isPasswordValid = false;

  bool obscureNew = true;
  bool obscureConfirm = true;

  void toggleNewVisibility() {
    setState(() {
      obscureNew = !obscureNew;
    });
  }

  void validateNewPassword(String newPassword) {
    setState(() {
      if (newPassword.isEmpty) {
        newPasswordErrorMessage = 'Password is required';
      } else if (!DeviceUtils.passwordRegex.hasMatch(newPassword)) {
        newPasswordErrorMessage =
            'Password must contain at least one uppercase letter, lowercase letter, number, special character and be between 8 to 32 characters long';
      } else {
        newPasswordErrorMessage = null;
      }
    });
  }

  void validateConfirmPassword(String confirmPassword) {
    setState(() {
      if (confirmPassword.isEmpty) {
        confirmPasswordErrorMessage = 'Password is required';
      } else if (!DeviceUtils.passwordRegex.hasMatch(confirmPassword)) {
        confirmPasswordErrorMessage =
            'Password must contain at least one uppercase letter, lowercase letter, number, special character and be between 8 to 32 characters long';
      } else if (confirmPassword.trim() != newPasswordController.text.trim()) {
        confirmPasswordErrorMessage =
            'Password and Confirm Password doesn\'t match';
      } else {
        confirmPasswordErrorMessage = null;
      }
    });
  }

  void toggleConfirmVisibility() {
    setState(() {
      obscureConfirm = !obscureConfirm;
    });
  }

  void _onVerifyPressed() {
    validateNewPassword(newPasswordController.text);
    validateConfirmPassword(confirmPasswordController.text);
    if (confirmPasswordErrorMessage == null &&
        newPasswordErrorMessage == null) {
      // Submit password to backend
      Future.delayed(Duration.zero, () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ResetPasswordSuccessful(),
        );
      });

      // Navigate if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:
          (_, __) => Scaffold(
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.minHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                        padding: EdgeInsets.only(left: 20.h),
                                        icon: DeviceUtils.backIcon(
                                          'assets/icons/back.svg',
                                          AppColors.neutral100,
                                          16,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                    Text(
                                      'Reset Password',
                                      style: AppTextTheme.fallback(
                                        isTablet: isTablet,
                                      ).bodyLargeSemiBold!.copyWith(
                                        color: AppColors.neutral100,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 24.w,
                                    right: 24.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15.h),
                                      Text(
                                        'Reset Password',
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).headingH4SemiBold!.copyWith(
                                          color: AppColors.neutral100,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Your new password must be different from the previously used password',
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).bodyMediumMedium!.copyWith(
                                          color: AppColors.neutral60,
                                        ),
                                      ),
                                      SizedBox(height: 35.h),

                                      // New Password Field
                                      Text(
                                        "New Password",
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).bodyMediumMedium!.copyWith(
                                          color: AppColors.neutral100,
                                        ),
                                      ),

                                      SizedBox(height: 8.h),
                                      CustomTextField(
                                        controller: newPasswordController,
                                        hintText: "Enter New Password",
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        isPassword: true,
                                        obscureText: obscureNew,
                                        onTap: () {},
                                        onVisibilityTap:
                                            () => toggleNewVisibility(),
                                        onChanged:
                                            (value) =>
                                                validateNewPassword(value),
                                        errorText: newPasswordErrorMessage,
                                      ),

                                      SizedBox(height: 24.h),

                                      // Confirm Password Field
                                      Text(
                                        "Confirm Password",
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).bodyMediumMedium!.copyWith(
                                          color: AppColors.neutral100,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      CustomTextField(
                                        controller: confirmPasswordController,
                                        hintText: "Enter Confirm Password",
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        isPassword: true,
                                        obscureText: obscureConfirm,
                                        onTap: () {},
                                        onVisibilityTap:
                                            () => toggleConfirmVisibility(),
                                        onChanged:
                                            (value) =>
                                                validateConfirmPassword(value),
                                        errorText: confirmPasswordErrorMessage,
                                      ),

                                      // Verify Button
                                      SizedBox(height: 30.h),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _onVerifyPressed,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16.h,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                            ),
                                          ),
                                          child: Text(
                                            "Continue",
                                            style: AppTextTheme.fallback(
                                              isTablet: isTablet,
                                            ).bodyMediumSemiBold!.copyWith(
                                              color: AppColors.neutral0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
    );
  }
}
