import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/providers/email_validation_notifier.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/screens/link_expired_dialog.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/text_styles.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
  final FocusNode emailFocus = FocusNode();
  bool emailTouched = false;
  bool isValidEmail = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(validateForm);
    emailFocus.addListener(() {
      if (!emailFocus.hasFocus) {
        setState(() {
          emailTouched = true;
        });
      }
    });
  }

  Future<void> onForgotPasswordTap() async {
    if (!isFormValid) return;

    await ref.read(emailValidationProvider.notifier).validate(emailController.text);

    final result = ref.read(emailValidationProvider);

    result.when(
      data: (response) async {
        if (response?.isEmailLinkUser == true) {
          try {
            await Supabase.instance.client.auth.resetPasswordForEmail(
              emailController.text,
              redirectTo: 'io.supabase.flutterquickstart://callback/reset-password',
            );

            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reset password link sent to ${emailController.text}')));
            context.goNamed('login');
          } on AuthException catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Supabase Error: ${e.message}')));
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unexpected error occurred')));
          }

          //ref.read(showResetPasswordSheetProvider.notifier).state = false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This email is linked to social login.')));
        }
      },
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      },
      loading: () {
        // UI already shows CircularProgressIndicator
      },
    );
  }

  void validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      isFormValid = isValid && isValidEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emailValidationProvider);
    final message = ref.read(linkExpiredMessage);
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LinkExpiredDialog.show(context, message);
        ref.watch(linkExpiredMessage.notifier).state = '';
      });
    }
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder:
          (context, child) => Scaffold(
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
                            Text("Forgot Password?", style: textTheme.headingH4SemiBold!.copyWith(color: context.colors.generalText)),
                            SizedBox(height: 8.h),
                            Text(
                              "Enter your email address and we’ll send you \nconfirmation code to reset your password",
                              style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787),
                            ),
                            SizedBox(height: 32.h),

                            Form(
                              key: _formKey,
                              onChanged: validateForm,
                              // Re-validate on any change
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email Address", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                  SizedBox(height: 8.h),

                                  CustomFormField(
                                    controller: emailController,
                                    focusNode: emailFocus,
                                    hintText: "Enter your email id",
                                    keyboardType: TextInputType.emailAddress,
                                    onTap: () {
                                      if (!emailTouched) {
                                        setState(() {
                                          emailTouched = true;
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (!emailTouched) {
                                        return null;
                                      }
                                      if (value == null || value.isEmpty) {
                                        isValidEmail = false;
                                        return '⦿ Email is required';
                                      }
                                      if (!emailRegex.hasMatch(value)) {
                                        isValidEmail = false;
                                        return '⦿ Enter a valid email';
                                      }
                                      isValidEmail = true;
                                      return null;
                                    },
                                    //label: "Email Address",
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state.isLoading || !isFormValid ? null : onForgotPasswordTap,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isFormValid ? context.colors.primary : context.colors.defaultGrayEEEEEE,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                ),
                                child:
                                    state.isLoading
                                        ? CircularProgressIndicator()
                                        : Text(
                                          "Continue",
                                          style: textTheme.bodyMediumSemiBold!.copyWith(
                                            color: isFormValid ? context.colors.defaultWhite : context.colors.defaultGray878787,
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
                                      style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText),
                                      children: [TextSpan(text: "Sign In", style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.primary))],
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
