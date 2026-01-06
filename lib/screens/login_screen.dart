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
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/personal_data_viewmodel.dart';
import 'package:smart_flutter/viewmodels/register_viewmodel.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneLoginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
  bool obscureText = true;

  bool isFormValid = false;
  bool isPhoneLoginFormValid = false;
  bool isValidPhoneNumber = false;

  bool isEmailValid = false;
  bool isPasswordValid = false;

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final FocusNode phoneNumberFocus = FocusNode();

  bool phoneNumberTouched = false;

  bool emailTouched = false;
  bool passwordTouched = false;

  bool isPhoneLogin = false;

  @override
  void initState() {
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);
    phoneNumberController.addListener(validatePhoneLoginForm);
    emailFocus.addListener(() {
      if (!emailFocus.hasFocus) {
        setState(() {
          emailTouched = true;
        });
      }
    });

    passwordFocus.addListener(() {
      if (!passwordFocus.hasFocus) {
        setState(() {
          passwordTouched = true;
        });
      }
    });

    phoneNumberFocus.addListener(() {
      if (!phoneNumberFocus.hasFocus) {
        setState(() {
          phoneNumberTouched = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void validatePhoneLoginForm() {
    final isValid = phoneLoginFormKey.currentState?.validate() ?? false;
    setState(() => isPhoneLoginFormValid = isValid && isValidPhoneNumber);
  }

  void validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => isFormValid = isValid && isEmailValid && isPasswordValid);
  }

  void phoneLoginProcess() async {
    FocusScope.of(context).unfocus();
    if (!isPhoneLoginFormValid) return;

    // Call the ViewModel
    await ref.read(registerViewModelProvider.notifier).phoneLogin(phoneNumber: phoneNumberController.text);

    final result = ref.read(registerViewModelProvider);

    result.when(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP sent on ${phoneNumberController.text}')));
        context.goNamed('phoneOtpVerification', pathParameters: {'phone': phoneNumberController.text});
      },
      error: (error, _) {
        print('Error: $error');
        //context.goNamed('phoneOtpVerification', pathParameters: {'phone': phoneNumberController.text});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      },
      loading: () {
        // UI already shows CircularProgressIndicator
      },
    );
  }

  void loginProcess() async {
    FocusScope.of(context).unfocus();
    if (!isFormValid) return;

    // Call the ViewModel
    await ref.read(registerViewModelProvider.notifier).login(email: emailController.text, password: passwordController.text);

    final result = ref.read(registerViewModelProvider);

    result.when(
      data: (_) {
        SharedPreferencesService.updateAuthFlags(userLoggedIn: true);
        // SharedPreferencesService.setUserLoggedIn(true);
        // SharedPreferencesService.setPhoneOTPAuthenticated(false);
        ref.read(tabIndexProvider.notifier).state = 0;
        ref.invalidate(personalDataProvider);
        // Go to home screen
        context.goNamed('home');
      },
      error: (error, _) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      },
      loading: () {
        // UI already shows CircularProgressIndicator
      },
    );
  }

  Future<void> signInWithProvider(OAuthProvider provider, BuildContext context) async {
    final supabase = Supabase.instance.client;

    try {
      // Web platform
      if (kIsWeb) {
        await supabase.auth.signInWithOAuth(provider, redirectTo: 'io.supabase.flutterquickstart://callback/social-media-login');
      }
      // Mobile platforms (Android/iOS)
      else {
        FocusScope.of(context).unfocus();
        await supabase.auth.signInWithOAuth(
          provider,
          authScreenLaunchMode: LaunchMode.inAppBrowserView,
          redirectTo: 'io.supabase.flutterquickstart://callback/social-media-login', // matches your scheme
        );
      }
    } catch (e) {
      debugPrint('OAuth SignIn Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.read(linkExpiredMessage);
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    final String iconPath = isPhoneLogin ? 'assets/icons/email_password.svg' : 'assets/icons/otp_icon.svg';
    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LinkExpiredDialog.show(context, message);
        ref.watch(linkExpiredMessage.notifier).state = '';
      });
    }
    final state = ref.watch(registerViewModelProvider);

    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder:
          (_, __) => Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.minHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Text("Login to your account.", style: textTheme.headingH4SemiBold!.copyWith(color: context.colors.generalText)),
                              SizedBox(height: 8.h),
                              Text("Please sign in to your account", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787)),
                              SizedBox(height: 32.h),

                              if (isPhoneLogin)
                                Form(
                                  key: phoneLoginFormKey,
                                  onChanged: validatePhoneLoginForm,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Phone Number", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                      SizedBox(height: 8.h),
                                      CustomFormField(
                                        controller: phoneNumberController,
                                        focusNode: phoneNumberFocus,
                                        hintText: "Enter your phone number",
                                        keyboardType: TextInputType.phone,
                                        onTap: () {
                                          if (!phoneNumberTouched) {
                                            setState(() {
                                              phoneNumberTouched = true;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (!phoneNumberTouched) {
                                            return null;
                                          }
                                          if (value == null || value.isEmpty) {
                                            isValidPhoneNumber = false;
                                            return '⦿ Phone number is required';
                                          } else if (value.length < 10) {
                                            isValidPhoneNumber = false;
                                            return '⦿ Enter a valid phone number';
                                          }
                                          isValidPhoneNumber = true;
                                          return null;
                                        },
                                        textInputAction: TextInputAction.done,
                                      ),
                                      SizedBox(height: 16.h),
                                    ],
                                  ),
                                )
                              else
                                Form(
                                  key: _formKey,
                                  onChanged: validateForm,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Email Address", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                      SizedBox(height: 8.h),
                                      CustomFormField(
                                        controller: emailController,
                                        focusNode: emailFocus,
                                        hintText: "Enter Email",
                                        keyboardType: TextInputType.emailAddress,
                                        onTap: () {
                                          if (!emailTouched) {
                                            setState(() {
                                              emailTouched = true;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (!emailTouched) return null;
                                          if (value == null || value.isEmpty) {
                                            isEmailValid = false;
                                            return '⦿ Email is required';
                                          }
                                          if (!emailRegex.hasMatch(value)) {
                                            isEmailValid = false;
                                            return '⦿ Enter a valid email';
                                          }
                                          isEmailValid = true;
                                          return null;
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text("Password", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                      SizedBox(height: 8.h),
                                      CustomFormField(
                                        controller: passwordController,
                                        focusNode: passwordFocus,
                                        hintText: "Password",
                                        isPassword: true,
                                        obscureText: obscureText,
                                        keyboardType: TextInputType.visiblePassword,
                                        onVisibilityTap: () {
                                          setState(() {
                                            obscureText = !obscureText;
                                          });
                                        },
                                        onTap: () {
                                          if (!passwordTouched) {
                                            setState(() {
                                              passwordTouched = true;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (!passwordTouched) return null;
                                          if (value == null || value.isEmpty) {
                                            isPasswordValid = false;
                                            return '⦿ Password is required';
                                          }
                                          isPasswordValid = true;
                                          return null;
                                        },
                                        textInputAction: TextInputAction.done,
                                      ),
                                      SizedBox(height: 4.h),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            context.pushNamed('forgotPassword');
                                          },
                                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                          child: Text("Forgot password?", style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.primary)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              SizedBox(height: 16.h),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      state.isLoading || !(isPhoneLogin ? isPhoneLoginFormValid : isFormValid)
                                          ? null
                                          : isPhoneLogin
                                          ? phoneLoginProcess
                                          : loginProcess,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        (isPhoneLogin ? isPhoneLoginFormValid : isFormValid) ? context.colors.primary : context.colors.defaultGrayEEEEEE,
                                    padding: EdgeInsets.symmetric(vertical: 16.h),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                  ),
                                  child:
                                      state.isLoading
                                          ? CircularProgressIndicator()
                                          : Text(
                                            isPhoneLogin ? "Proceed" : "Sign In",
                                            style: textTheme.bodyMediumSemiBold!.copyWith(
                                              color:
                                                  (isPhoneLogin ? isPhoneLoginFormValid : isFormValid)
                                                      ? context.colors.defaultWhite
                                                      : context.colors.defaultGray878787,
                                            ),
                                          ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: context.colors.defaultGray878787)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Text("Or sign in with", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787)),
                                  ),
                                  Expanded(child: Divider(color: context.colors.defaultGray878787)),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPhoneLogin = !isPhoneLogin;
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    child: DeviceUtils.socialIcon(iconPath, context.colors.defaultGrayEEEEEE),
                                  ),
                                  SizedBox(width: 16.w),
                                  GestureDetector(
                                    onTap: () {
                                      signInWithProvider(OAuthProvider.google, context);
                                    },
                                    child: DeviceUtils.socialIcon("assets/icons/google.svg", context.colors.defaultGrayEEEEEE),
                                  ),
                                  SizedBox(width: 16.w),
                                  GestureDetector(
                                    onTap: () {
                                      signInWithProvider(OAuthProvider.twitter, context);
                                    },
                                    child: DeviceUtils.socialIcon("assets/icons/twitter.svg", context.colors.defaultGrayEEEEEE),
                                  ),
                                  SizedBox(width: 16.w),
                                  GestureDetector(
                                    onTap: () {
                                      signInWithProvider(OAuthProvider.facebook, context);
                                    },
                                    child: DeviceUtils.socialIcon("assets/icons/facebook.svg", context.colors.defaultGrayEEEEEE),
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
                                        style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText),
                                        children: [TextSpan(text: "Register", style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.primary))],
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
          ),
    );
  }
}
