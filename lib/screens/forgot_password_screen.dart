import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/providers/email_validation_notifier.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/screens/link_expired_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/text_styles.dart';
import '../views/widgets/login_screen/custom_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onForgotPasswordTap(String email) async {
    await ref.read(emailValidationProvider.notifier).validate(email);

    final result = ref.read(emailValidationProvider);

    result.whenOrNull(
      data: (response) async {
        if (response?.isEmailLinkUser == true) {
          try {
            await Supabase.instance.client.auth.resetPasswordForEmail(
              email,
              redirectTo: 'https://jpi.nub.mybluehostin.me/reset-password',
            );

            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reset password link sent to $email')),
            );
            context.goNamed('login');
            //context.goNamed('emailOtpVerification',); // 👈 navigate to your verification screen
          } on AuthException catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Supabase Error: ${e.message}')),
            );
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unexpected error occurred')),
            );
          }

          //ref.read(showResetPasswordSheetProvider.notifier).state = false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This email is linked to social login.'),
            ),
          );
        }
      },
      error: (error, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emailValidationProvider);
    final message = ref.read(linkExpiredMessage);

    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LinkExpiredDialog.show(context, message);
        ref.watch(linkExpiredMessage.notifier).state = '';
      });
    }
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:
          (context, child) => Scaffold(
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.minHeight,
                      ),
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
                                  state.isLoading
                                      ? null
                                      : onForgotPasswordTap(
                                        emailController.text,
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryAccent,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                                child:
                                    state.isLoading
                                        ? const CircularProgressIndicator()
                                        : Text(
                                          "Continue",
                                          style: AppTextTheme.fallback(
                                            isTablet: isTablet,
                                          ).bodyMediumSemiBold!.copyWith(
                                            color: AppColors.neutral0,
                                          ),
                                        ),
                              ),
                            ),

                            SizedBox(height: 30.h),

                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: GestureDetector(
                                  onTap: () {
                                    context.goNamed('login');
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already register? ",
                                      style: AppTextTheme.fallback(
                                        isTablet: isTablet,
                                      ).bodyMediumMedium!.copyWith(
                                        color: AppColors.neutral100,
                                      ),
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
          ),
    );
  }
}
