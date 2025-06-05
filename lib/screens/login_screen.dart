import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/screens/register_screen.dart';

import '../core/constants/app_colors.dart';
import '../views/widgets/login_screen/custom_text_field.dart';
import 'forgot_password_contact_details_screen.dart';
import 'forgot_password_screen.dart';
import 'persistent_bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  final bool shouldForgotPasswordModelOnLoad;

  const LoginScreen({super.key, required this.shouldForgotPasswordModelOnLoad});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    if (widget.shouldForgotPasswordModelOnLoad) {
      Future.delayed(Duration.zero, () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ForgotPasswordContactDetailsScreen(),
        );
      });
    }
  }

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
                        "Login to your\naccount.",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .headingH4SemiBold!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Please sign in to your account",
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
                      SizedBox(height: 16.h),

                      Text(
                        "Password",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .bodyMediumMedium!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: passwordController,
                        hintText: "Password",
                        isPassword: true,
                        obscureText: obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        onVisibilityTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        onTap: () {},
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot password?",
                            style: AppTextTheme.fallback(isTablet: isTablet)
                                .bodyMediumMedium!
                                .copyWith(color: AppColors.primaryAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PersistentBottomNavigation(),
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
                            "Sign In",
                            style: AppTextTheme.fallback(isTablet: isTablet)
                                .bodyMediumSemiBold!
                                .copyWith(color: AppColors.neutral0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.neutral60)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "Or sign in with",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral60),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.neutral60)),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DeviceUtils.socialIcon("assets/icons/google.svg"),
                          SizedBox(width: 16.w),
                          DeviceUtils.socialIcon("assets/icons/facebook.svg"),
                          SizedBox(width: 16.w),
                          DeviceUtils.socialIcon("assets/icons/apple.svg"),
                        ],
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
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: AppTextTheme.fallback(isTablet: isTablet)
                                    .bodyMediumMedium!
                                    .copyWith(color: AppColors.neutral100),
                                children: [
                                  TextSpan(
                                    text: "Register",
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
