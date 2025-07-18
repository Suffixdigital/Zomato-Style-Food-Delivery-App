import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/screens/link_expired_dialog.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/viewmodels/register_viewmodel.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/app_colors.dart';
import '../viewmodels/personal_data_viewmodel.dart';
import 'forgot_password_contact_details_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
  bool obscureText = true;

  bool isFormValid = false;

  // bool hasShowingShet = false;

  @override
  void initState() {
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => isFormValid = isValid);
  }

  void loginProcess() async {
    if (!isFormValid) return;

    // Call the ViewModel
    await ref
        .read(registerViewModelProvider.notifier)
        .login(email: emailController.text, password: passwordController.text);

    final result = ref.read(registerViewModelProvider);

    result.when(
      data: (_) {
        SharedPreferencesService.setUserLoggedIn(true);
        ref.read(tabIndexProvider.notifier).state = 0;
        ref.invalidate(personalDataProvider);
        // Go to home screen
        context.goNamed('home');
      },
      error: (error, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      },
      loading: () {
        // UI already shows CircularProgressIndicator
      },
    );
  }

  Future<void> signInWithProvider(
    OAuthProvider provider,
    BuildContext context,
  ) async {
    final supabase = Supabase.instance.client;

    try {
      // 🌐 Web platform
      if (kIsWeb) {
        await supabase.auth.signInWithOAuth(
          provider,
          redirectTo: 'https://<your-project-ref>.supabase.co/auth/v1/callback',
        );
      }
      // 📱 Mobile platforms (Android/iOS)
      else {
        await supabase.auth.signInWithOAuth(
          provider,
          authScreenLaunchMode: LaunchMode.externalApplication,
          redirectTo:
              'https://jpi.nub.mybluehostin.me/callback', // matches your scheme
        );
      }
    } catch (e) {
      debugPrint('OAuth SignIn Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.read(linkExpiredMessage);

    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LinkExpiredDialog.show(context, message);
        ref.watch(linkExpiredMessage.notifier).state = '';
      });
    }
    final state = ref.watch(registerViewModelProvider);
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    final shouldShow = ref.read(showResetPasswordSheetProvider);

    print('didChangeDependencies() called $shouldShow');
    if (shouldShow) {
      Future.delayed(Duration.zero, () {
        ref.read(showResetPasswordSheetProvider.notifier).state = false;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ForgotPasswordContactDetailsScreen(context: context),
        );
      });
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:
          (_, __) => Scaffold(
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

                            Form(
                              key: _formKey,
                              onChanged: validateForm,
                              // Re-validate on any change
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email Address",
                                    style: AppTextTheme.fallback(
                                      isTablet: isTablet,
                                    ).bodyMediumMedium!.copyWith(
                                      color: AppColors.neutral100,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomFormField(
                                    controller: emailController,
                                    hintText: "Enter Email",
                                    keyboardType: TextInputType.emailAddress,
                                    onTap: () {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '• Email is required';
                                      }
                                      if (!emailRegex.hasMatch(value)) {
                                        return '• Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    "Password",
                                    style: AppTextTheme.fallback(
                                      isTablet: isTablet,
                                    ).bodyMediumMedium!.copyWith(
                                      color: AppColors.neutral100,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomFormField(
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '• Password is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // context.goNamed('forgotPassword');
                                  context.pushNamed('forgotPassword');
                                },
                                child: Text(
                                  "Forgot password?",

                                  style: AppTextTheme.fallback(
                                    isTablet: isTablet,
                                  ).bodyMediumSemiBold!.copyWith(
                                    color: AppColors.primaryAccent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    state.isLoading || !isFormValid
                                        ? null
                                        : loginProcess,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                                child:
                                    state.isLoading
                                        ? const CircularProgressIndicator()
                                        : Text(
                                          "Sign In",
                                          style: AppTextTheme.fallback(
                                            isTablet: isTablet,
                                          ).bodyMediumSemiBold!.copyWith(
                                            color: AppColors.neutral0,
                                          ),
                                        ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: AppColors.neutral60),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                  ),
                                  child: Text(
                                    "Or sign in with",
                                    style: AppTextTheme.fallback(
                                      isTablet: isTablet,
                                    ).bodyMediumMedium!.copyWith(
                                      color: AppColors.neutral60,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: AppColors.neutral60),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    signInWithProvider(
                                      OAuthProvider.google,
                                      context,
                                    );
                                  },
                                  child: DeviceUtils.socialIcon(
                                    "assets/icons/google.svg",
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                GestureDetector(
                                  onTap: () {
                                    signInWithProvider(
                                      OAuthProvider.twitter,
                                      context,
                                    );
                                  },
                                  child: DeviceUtils.socialIcon(
                                    "assets/icons/twitter.svg",
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                GestureDetector(
                                  onTap: () {
                                    signInWithProvider(
                                      OAuthProvider.facebook,
                                      context,
                                    );
                                  },
                                  child: DeviceUtils.socialIcon(
                                    "assets/icons/facebook.svg",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: GestureDetector(
                                  onTap: () {
                                    context.goNamed('register');
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Don't have an account? ",
                                      style: AppTextTheme.fallback(
                                        isTablet: isTablet,
                                      ).bodyMediumMedium!.copyWith(
                                        color: AppColors.neutral100,
                                      ),
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
          ),
    );
  }
}
