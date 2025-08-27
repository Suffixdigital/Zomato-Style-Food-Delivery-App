import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/screens/confirmation_dialog.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/register_viewmodel.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_form_field.dart';
import 'package:smart_flutter/views/widgets/reset_password_screen/reset_password_success.dart';

import '../core/constants/text_styles.dart';
import '../core/utils/device_utils.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  bool isFormValid = false;
  bool obscureNew = true;
  bool obscureConfirm = true;
  bool passwordTouched = false;
  bool confirmPasswordTouched = false;

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);

    passwordFocus.addListener(() {
      if (!passwordFocus.hasFocus) setState(() => passwordTouched = true);
    });

    confirmPasswordFocus.addListener(() {
      if (!confirmPasswordFocus.hasFocus) setState(() => confirmPasswordTouched = true);
    });
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  void validateForm() {
    final formState = _formKey.currentState;
    if (formState != null) {
      setState(() {
        isFormValid = formState.validate();
      });
    }
  }

  String? passwordValidator(String? value, {required bool isConfirm}) {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final touched = isConfirm ? confirmPasswordTouched : passwordTouched;

    if (!touched) return null;
    if (value == null || value.isEmpty) return '⦿ Password is required';

    if (!DeviceUtils.passwordRegex.hasMatch(value)) {
      return '⦿ Must contain uppercase, lowercase, number, special char & 8–32 chars';
    }

    if (isConfirm && value != newPassword) {
      return '⦿ Password and Confirm Password don\'t match';
    } else if (!isConfirm && value != confirmPassword) {
      return '⦿ Password and Confirm Password don\'t match';
    }

    return null;
  }

  void toggleVisibility({required bool isConfirm}) {
    setState(() {
      if (isConfirm) {
        obscureConfirm = !obscureConfirm;
      } else {
        obscureNew = !obscureNew;
      }
    });
  }

  Future<bool> onBackPressed() async {
    ConfirmationDialog.show(context, 'Confirmation!', 'Are you sure to open Login screen without completing reset password process?');
    return false;
  }

  Future<void> onVerifyPressed() async {
    if (!isFormValid) return;

    await ref.read(registerViewModelProvider.notifier).setUserPassword(password: newPasswordController.text);

    final result = ref.read(registerViewModelProvider);

    result.when(
      data: (_) {
        SharedPreferencesService.setResetPassword(false);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const ResetPasswordSuccessful(isPasswordSet: false),
        );
      },
      error: (_, __) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to set password')));
      },
      loading: () {
        // Already shows CircularProgressIndicator
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    final state = ref.watch(registerViewModelProvider);

    return WillPopScope(
      onWillPop: onBackPressed,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder:
            (_, __) => Scaffold(
              body: SafeArea(
                child: LayoutBuilder(
                  builder:
                      (context, constraints) => SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.minHeight),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top App Bar
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          padding: EdgeInsets.only(left: 20.w),
                                          icon: DeviceUtils.backIcon('assets/icons/back.svg', context.colors.generalText, 16),
                                          onPressed: () => onBackPressed(),
                                        ),
                                      ),
                                      Text('Reset Password', style: textTheme.bodyLargeSemiBold!.copyWith(color: context.colors.generalText)),
                                    ],
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15.h),
                                        Text('Reset Password', style: textTheme.headingH4SemiBold!.copyWith(color: context.colors.generalText)),
                                        SizedBox(height: 10.h),
                                        Text(
                                          'Your new password must be different from the previously used password',
                                          style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787),
                                        ),
                                        SizedBox(height: 35.h),

                                        // Password Form
                                        Form(
                                          key: _formKey,
                                          onChanged: validateForm,
                                          autovalidateMode: AutovalidateMode.disabled,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("New Password", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                              SizedBox(height: 8.h),
                                              CustomFormField(
                                                controller: newPasswordController,
                                                focusNode: passwordFocus,
                                                hintText: "Enter New Password",
                                                isPassword: true,
                                                obscureText: obscureNew,
                                                keyboardType: TextInputType.visiblePassword,
                                                onVisibilityTap: () => toggleVisibility(isConfirm: false),
                                                onTap: () => setState(() => passwordTouched = true),
                                                validator: (value) => passwordValidator(value, isConfirm: false),
                                              ),

                                              SizedBox(height: 24.h),

                                              Text("Confirm Password", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                              SizedBox(height: 8.h),
                                              CustomFormField(
                                                controller: confirmPasswordController,
                                                focusNode: confirmPasswordFocus,
                                                hintText: "Enter Confirm Password",
                                                isPassword: true,
                                                obscureText: obscureConfirm,
                                                keyboardType: TextInputType.visiblePassword,
                                                onVisibilityTap: () => toggleVisibility(isConfirm: true),
                                                onTap: () => setState(() => confirmPasswordTouched = true),
                                                validator: (value) => passwordValidator(value, isConfirm: true),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 30.h),

                                        // Submit Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: state.isLoading || !isFormValid ? null : onVerifyPressed,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isFormValid ? context.colors.primary : context.colors.defaultGrayEEEEEE,
                                              padding: EdgeInsets.symmetric(vertical: 16.h),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                            ),
                                            child:
                                                state.isLoading
                                                    ? const CircularProgressIndicator()
                                                    : Text(
                                                      "Continue",
                                                      style: textTheme.bodyMediumSemiBold!.copyWith(
                                                        color: isFormValid ? context.colors.defaultWhite : context.colors.defaultGray878787,
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
                ),
              ),
            ),
      ),
    );
  }
}
