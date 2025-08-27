import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/screens/link_expired_dialog.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/register_viewmodel.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final TextEditingController dobController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));

  final _dobController = TextEditingController();

  final TextEditingController genderController = TextEditingController();

  bool isFormValid = false;

  bool agreeTerms = false;
  bool isValidFullName = false;
  bool isValidEmail = false;
  bool isValidPhoneNumber = false;

  final genderOptions = ['Male', 'Female'];
  String selectedGender = 'Male';

  final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

  final FocusNode emailFocus = FocusNode();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode phoneNumberFocus = FocusNode();
  final FocusNode dobFocus = FocusNode();

  bool emailTouched = false;
  bool fullNameTouched = false;
  bool phoneNumberTouched = false;
  bool dobTouched = false;

  void registerUser() async {
    if (!isFormValid) return;

    // Call the ViewModel
    await ref
        .read(registerViewModelProvider.notifier)
        .registerUser(
          email: emailController.text,
          fullName: fullNameController.text,
          dob: dobController.text,
          gender: selectedGender.toLowerCase(),
          phoneNumber: phoneNumberController.text,
        );

    final result = ref.read(registerViewModelProvider);

    result.when(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email link sent successfully!')));
      },
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
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
        await supabase.auth.signInWithOAuth(
          provider,
          redirectTo: 'io.supabase.flutterquickstart://callback/social-media-login', // matches your scheme
        );
      }
    } catch (e) {
      debugPrint('OAuth SignIn Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  Future<void> selectDate() async {
    final initialDate = dobController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(dobController.text) : DateTime.now();

    if (Platform.isAndroid) {
      DateTime? picked = await showDatePicker(
        cancelText: "Cancel",
        confirmText: "OK",
        helpText: "Select your date of birth",
        errorFormatText: "Invalid date format",
        fieldHintText: "DD/MM/YYYY",
        fieldLabelText: "Date of Birth",
        errorInvalidText: "Invalid date",
        context: context,
        locale: Locale('en', 'GB'),
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme:
                  isDarkMode
                      ? ColorScheme.dark(
                        primary: context.colors.primary,
                        onPrimary: context.colors.onPrimary,
                        surface: context.colors.surface,
                        onSurface: context.colors.onSurface,
                      )
                      : ColorScheme.light(
                        primary: context.colors.primary,
                        onPrimary: context.colors.onPrimary,
                        surface: context.colors.surface,
                        onSurface: context.colors.onSurface,
                      ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: context.colors.primary, textStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              textTheme: TextTheme(
                titleLarge: TextStyle(color: context.colors.onSurface, fontSize: 18, fontWeight: FontWeight.w600),
                labelLarge: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 14),
                bodyLarge: TextStyle(color: context.colors.onSurface),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: isDarkMode ? Color(0xFF2C2C2E) : Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: context.colors.primary)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: context.colors.primary)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: context.colors.primary, width: 2)),
                hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey),
                labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
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
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      picker.DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(),
        currentTime: initialDate,
        theme: picker.DatePickerTheme(
          backgroundColor: context.colors.surface,
          itemStyle: TextStyle(color: context.colors.onSurface, fontWeight: FontWeight.w700, fontSize: 18.sp),
          doneStyle: TextStyle(color: context.colors.primary, fontWeight: FontWeight.w700, fontSize: 16.sp),
          cancelStyle: TextStyle(color: context.colors.primary, fontWeight: FontWeight.w700, fontSize: 16),
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
    setState(() {
      isFormValid = isValid && isValidFullName && isValidEmail && isValidPhoneNumber && agreeTerms && selectedGender.isNotEmpty;
    });
  }

  @override
  void initState() {
    fullNameController.addListener(validateForm);
    emailController.addListener(validateForm);
    dobController.addListener(validateForm);
    phoneNumberController.addListener(validateForm);
    fullNameFocus.addListener(() {
      if (!fullNameFocus.hasFocus) {
        setState(() {
          fullNameTouched = true;
        });
      }
    });

    emailFocus.addListener(() {
      if (!emailFocus.hasFocus) {
        setState(() {
          emailTouched = true;
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

    dobFocus.addListener(() {
      if (!dobFocus.hasFocus) {
        setState(() {
          dobTouched = true;
        });
      }
    });
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
    final message = ref.read(linkExpiredMessage);
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LinkExpiredDialog.show(context, message);
        ref.watch(linkExpiredMessage.notifier).state = '';
      });
    }
    final state = ref.watch(registerViewModelProvider);
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
                            Text("Create your new account", style: textTheme.headingH4SemiBold!.copyWith(color: context.colors.generalText)),
                            SizedBox(height: 8.h),
                            Text(
                              "Create an account to start looking for the food you like",
                              style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787),
                            ),
                            SizedBox(height: 12.h),

                            Form(
                              key: _formKey,
                              onChanged: validateForm,
                              // Re-validate on any change
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Full Name", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                  SizedBox(height: 8.h),
                                  CustomFormField(
                                    hintText: "Enter your full name",
                                    controller: fullNameController,
                                    focusNode: fullNameFocus,
                                    onTap: () {
                                      if (!fullNameTouched) {
                                        setState(() {
                                          fullNameTouched = true;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (!fullNameTouched) {
                                        return null;
                                      }
                                      if (value == null || value.trim().isEmpty) {
                                        isValidFullName = false;
                                        return '⦿ Name is required';
                                      }
                                      if (value.length < 3) {
                                        isValidFullName = false;
                                        return '⦿ Enter at least 3 characters';
                                      }
                                      isValidFullName = true;
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),

                                  Text("Email ID", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
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
                                  SizedBox(height: 16.h),

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
                                  ),
                                  SizedBox(height: 16.h),

                                  Text("Date of birth", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                  SizedBox(height: 8.h),
                                  CustomFormField(
                                    controller: dobController,
                                    focusNode: dobFocus,
                                    hintText: "Date of Birth",
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                    onTap: selectDate,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '⦿ Date of birth is required';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  Text("Gender", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                  SizedBox(height: 8.h),
                                  Wrap(
                                    spacing: 20.w,
                                    runSpacing: 20.w,
                                    alignment: WrapAlignment.start,

                                    children:
                                        genderOptions.map((gender) {
                                          final isSelected = selectedGender == gender;
                                          return ChoiceChip(
                                            checkmarkColor: context.colors.defaultWhite,

                                            label: Text(
                                              gender,
                                              style: textTheme.bodyMediumMedium!.copyWith(
                                                color: isSelected ? context.colors.defaultWhite : context.colors.defaultBlack,
                                              ),
                                            ),
                                            selected: isSelected,
                                            selectedColor: context.colors.primary,
                                            backgroundColor: context.colors.defaultWhite,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.r),
                                              side: BorderSide(color: isSelected ? context.colors.primary : context.colors.defaultBlack),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                                        activeColor: context.colors.primary,
                                        checkColor: context.colors.defaultWhite,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: RichText(
                                            text: TextSpan(
                                              style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText),
                                              children: [
                                                TextSpan(text: "I Agree with "),
                                                TextSpan(
                                                  text: "Terms of Service",
                                                  style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.primary),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          // Navigate to terms screen or open dialog
                                                        },
                                                ),
                                                TextSpan(text: " and "),
                                                TextSpan(
                                                  text: "Privacy Policy",
                                                  style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.primary),
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
                                      onPressed: state.isLoading || !isFormValid ? null : registerUser,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isFormValid ? context.colors.primary : context.colors.defaultGrayEEEEEE,
                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                      ),
                                      child:
                                          state.isLoading
                                              ? const CircularProgressIndicator()
                                              : Text(
                                                "Register",
                                                style: textTheme.bodyMediumSemiBold!.copyWith(
                                                  color: isFormValid ? context.colors.defaultWhite : context.colors.defaultGray878787,
                                                ),
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(child: Divider(color: context.colors.defaultGray878787)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Text(
                                    "Or sign in with",
                                    style: AppTextTheme.fallback(isTablet: isTablet).bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787),
                                  ),
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
