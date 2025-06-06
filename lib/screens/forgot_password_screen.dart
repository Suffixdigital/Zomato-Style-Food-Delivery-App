import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/text_styles.dart';
import '../views/widgets/login_screen/custom_text_field.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.minHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        "Forgot Password?",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .headingH4SemiBold!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Enter your email address and we’ll send you \nconfirmation code to reset your password",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .bodyMediumMedium!
                            .copyWith(color: AppColors.neutral60),
                      ),
                      SizedBox(height: 32.h),

                      Text(
                        "Email Address",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .bodyMediumMedium!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: emailController,
                        hintText: "Enter Email",
                        keyboardType: TextInputType.emailAddress,
                        onTap: () {},
                      ),
                      SizedBox(height: 50.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LoginScreen(
                                      shouldForgotPasswordModelOnLoad: true,
                                    ),
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
                            style: AppTextTheme.fallback(isTablet: isTablet)
                                .bodyMediumSemiBold!
                                .copyWith(color: AppColors.neutral0),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const LoginScreen(
                                        shouldForgotPasswordModelOnLoad: false,
                                      ),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Already register? ",
                                style: AppTextTheme.fallback(isTablet: isTablet)
                                    .bodyMediumMedium!
                                    .copyWith(color: AppColors.neutral100),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
                                    style: AppTextTheme.fallback(
                                      isTablet: isTablet,
                                    ).bodyMediumSemiBold!.copyWith(
                                      color: AppColors.primaryAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
