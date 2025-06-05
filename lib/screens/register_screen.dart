import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/text_styles.dart';
import '../views/widgets/login_screen/custom_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  bool passwordVisible = false;
  bool agreeTerms = false;

  void togglePasswordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void toggleAgreement() {
    setState(() {
      agreeTerms = !agreeTerms;
    });
  }

  void registerUser() {
    // Register logic here
    debugPrint('Email: ${emailController.text}');
    debugPrint('Username: ${usernameController.text}');
    debugPrint('Password: ${passwordController.text}');
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
                        "Create your new account",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .headingH4SemiBold!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Create an account to start looking for the food you like",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .bodyMediumMedium!
                            .copyWith(color: AppColors.neutral60),
                      ),
                      SizedBox(height: 12.h),

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
                        //label: "Email Address",
                      ),

                      SizedBox(height: 16.h),

                      Text(
                        "User Name",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .bodyMediumMedium!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: usernameController,
                        hintText: "Enter Username",
                        keyboardType: TextInputType.name,
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
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        obscureText: obscureText,
                        onTap: () {},
                        onVisibilityTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                      SizedBox(height: 8.h),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: agreeTerms,
                            onChanged: (_) => toggleAgreement(),
                            activeColor: AppColors.primaryAccent,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: AppTextTheme.fallback(isTablet: isTablet)
                                    .bodyMediumMedium!
                                    .copyWith(color: AppColors.neutral100),
                                children: [
                                  TextSpan(text: "I Agree with "),
                                  TextSpan(
                                    text: "Terms of Service",
                                    style: AppTextTheme.fallback(
                                      isTablet: isTablet,
                                    ).bodyMediumSemiBold!.copyWith(
                                      color: AppColors.primaryAccent,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to terms screen or open dialog
                                          },
                                  ),
                                  TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: AppTextTheme.fallback(
                                      isTablet: isTablet,
                                    ).bodyMediumSemiBold!.copyWith(
                                      color: AppColors.primaryAccent,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to privacy screen or open dialog
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Text(
                            "Register",
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
                          DeviceUtils.socialIcon('assets/icons/google.svg'),
                          SizedBox(width: 16.w),
                          DeviceUtils.socialIcon('assets/icons/facebook.svg'),
                          SizedBox(width: 16.w),
                          DeviceUtils.socialIcon('assets/icons/apple.svg'),
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
