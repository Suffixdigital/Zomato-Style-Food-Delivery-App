import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/viewmodels/register_viewmodel.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_form_field.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/text_styles.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController dobController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  final TextEditingController genderController = TextEditingController();

  bool isFormValid = false;

  bool agreeTerms = false;

  final genderOptions = ['Male', 'Female'];
  String selectedGender = 'Male';

  final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

  void registerUser() async {
    if (!isFormValid) return;

    // Call the ViewModel
    await ref
        .read(registerViewModelProvider.notifier)
        .registerUser(
          name: fullNameController.text,
          email: emailController.text,
          phone: phoneNumberController.text,
          gender: selectedGender,
          dob: dobController.text,
        );

    final result = ref.read(registerViewModelProvider);

    result.when(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email link sent successfully!')),
        );
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

  Future<void> selectDate(
    BuildContext context,
    TextEditingController dobController,
  ) async {
    final initialDate =
        dobController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(dobController.text)
            : DateTime.now();

    if (Platform.isAndroid) {
      // ✅ Android: Material-style date picker
      DateTime? picked = await showDatePicker(
        cancelText: "Cancel",
        confirmText: "OK",
        helpText: "Select your date of birth",
        errorFormatText: "Invalid date format",
        fieldHintText: "Month/Date/Year",
        fieldLabelText: "Date of Birth",
        errorInvalidText: "Invalid date",
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryAccent,
                onPrimary: AppColors.neutral0,
                onSurface: AppColors.neutral100,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryAccent,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      }
    } else if (Platform.isIOS) {
      // ✅ iOS: iOS-style picker
      picker.DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(),
        currentTime: initialDate,
        theme: picker.DatePickerTheme(
          backgroundColor: AppColors.neutral0,
          itemStyle: TextStyle(
            color: AppColors.neutral100,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
          doneStyle: TextStyle(
            color: AppColors.primaryAccent,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
          cancelStyle: TextStyle(
            color: AppColors.primaryAccent,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          headerColor: Colors.transparent,
          containerHeight: 200.h,
        ),
        onConfirm: (date) {
          dobController.text = DateFormat('dd/MM/yyyy').format(date);
        },
        locale: picker.LocaleType.en,
      );
    }
  }

  void validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(
      () => isFormValid = isValid && agreeTerms && selectedGender.isNotEmpty,
    );
  }

  @override
  void initState() {
    fullNameController.addListener(validateForm);
    emailController.addListener(validateForm);
    dobController.addListener(validateForm);
    phoneNumberController.addListener(validateForm);
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewModelProvider);
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

                      Form(
                        key: _formKey,
                        onChanged: validateForm, // Re-validate on any change
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Full Name",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            CustomFormField(
                              hintText: "Enter your full name",
                              controller: fullNameController,
                              onTap: () {},
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '• Name is required';
                                }
                                if (value.length < 3) {
                                  return '• Enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            Text(
                              "Email ID",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            CustomFormField(
                              controller: emailController,
                              hintText: "Enter your email id",
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
                              //label: "Email Address",
                            ),

                            SizedBox(height: 16.h),
                            Text(
                              "Phone Number",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            CustomFormField(
                              controller: phoneNumberController,
                              hintText: "Enter your phone number",
                              keyboardType: TextInputType.phone,
                              onTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '• Phone number is required';
                                } else if (value.length < 10) {
                                  return '• Enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            Text(
                              "Date of birth",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            CustomFormField(
                              controller: dobController,
                              hintText: "Date of Birth",
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              onTap: () => selectDate(context, dobController),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '• Date of birth is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "Gender",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 20.w,
                              runSpacing: 20.w,
                              alignment: WrapAlignment.start,

                              children:
                                  genderOptions.map((gender) {
                                    final isSelected = selectedGender == gender;
                                    return ChoiceChip(
                                      checkmarkColor: AppColors.neutral0,

                                      label: Text(
                                        gender,
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).bodyMediumMedium!.copyWith(
                                          color:
                                              isSelected
                                                  ? AppColors.neutral0
                                                  : AppColors.neutral100,
                                        ),
                                      ),
                                      selected: isSelected,
                                      selectedColor: AppColors.primaryAccent,
                                      backgroundColor: AppColors.neutral0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        side: BorderSide(
                                          color:
                                              isSelected
                                                  ? AppColors.primaryAccent
                                                  : AppColors.neutral100
                                                      .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 10.h,
                                      ),
                                      onSelected: (_) {
                                        setState(() => selectedGender = gender);
                                        validateForm();
                                      },
                                    );
                                  }).toList(),
                            ),
                            SizedBox(height: 16.h),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: agreeTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      agreeTerms = value ?? false;
                                      validateForm();
                                    });
                                  },
                                  activeColor: AppColors.primaryAccent,
                                  checkColor: AppColors.neutral0,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(
                                    horizontal: -4,
                                    vertical: -4,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: RichText(
                                      text: TextSpan(
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).bodyMediumMedium!.copyWith(
                                          color: AppColors.neutral100,
                                        ),
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
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    state.isLoading || !isFormValid
                                        ? null
                                        : registerUser,
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
                                          "Register",
                                          style: AppTextTheme.fallback(
                                            isTablet: isTablet,
                                          ).bodyMediumSemiBold!.copyWith(
                                            color: AppColors.neutral0,
                                          ),
                                        ),
                              ),
                            ),

                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),

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
                              context.goNamed('login', extra: false);
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
