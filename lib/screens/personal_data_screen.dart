import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/user_model.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/personal_data_viewmodel.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_form_field.dart';
import 'package:smart_flutter/views/widgets/personal_data_screen/personal_data_header.dart';

class ProfileDataScreen extends ConsumerStatefulWidget {
  const ProfileDataScreen({super.key});

  @override
  ConsumerState createState() => _ProfileDataScreenState();
}

class _ProfileDataScreenState extends ConsumerState<ProfileDataScreen> {
  late TextEditingController fullNameController;
  late TextEditingController dobController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

  final FocusNode emailFocus = FocusNode();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode phoneNumberFocus = FocusNode();
  final FocusNode dobFocus = FocusNode();

  bool emailTouched = false;
  bool fullNameTouched = false;
  bool phoneNumberTouched = false;
  bool dobTouched = false;

  late String initialFullName, initialDob, initialPhone, initialEmail, initialGender;

  final genderOptions = ['Male', 'Female'];
  String selectedGender = 'Male';

  bool controllersInitialized = false;

  @override
  void initState() {
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

  void loadUserData(UserModel userData) {
    if (controllersInitialized) return;
    fullNameController = TextEditingController(text: userData.fullName);

    dobController = TextEditingController(text: userData.dateOfBirth.isNotEmpty ? userData.dateOfBirth : DateFormat('dd/MM/yyyy').format(DateTime.now()));
    phoneController = TextEditingController(text: userData.phone);
    emailController = TextEditingController(text: userData.email);
    selectedGender = userData.gender;

    initialFullName = fullNameController.text;
    initialDob = dobController.text;
    initialPhone = phoneController.text;
    initialEmail = emailController.text;
    initialGender = selectedGender;

    controllersInitialized = true;
  }

  bool _hasChanges = false;

  bool get hasChanges {
    return fullNameController.text != initialFullName ||
        dobController.text != initialDob ||
        phoneController.text != initialPhone ||
        emailController.text != initialEmail ||
        selectedGender != initialGender;
  }

  void saveProfile() {
    ref
        .read(personalDataProvider.notifier)
        .updateUser(
          UserModel(
            fullName: fullNameController.text,
            dateOfBirth: dobController.text,
            gender: selectedGender,
            phone: phoneController.text,
            email: emailController.text,
            provider: "",
          ),
        );

    final result = ref.read(personalDataProvider);

    result.when(
      data: (userdata) {
        _hasChanges = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Saved")));
      },
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $error')));
      },
      loading: () {
        // UI already shows CircularProgressIndicator
      },
    );
  }

  Future<void> selectDate() async {
    final initialDate = dobController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(dobController.text) : DateTime.now();

    if (Platform.isAndroid) {
      DateTime? picked = await showDatePicker(
        cancelText: "Cancel",
        confirmText: "OK",
        helpText: "Select your date of birth",
        errorFormatText: "⦿ Invalid date format",
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

  Future<bool> onBackPressed() async {
    if (hasChanges && !_hasChanges) {
      final textTheme = Theme.of(context).extension<AppTextTheme>()!;
      final result = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Save Changes?"),
              content: Text("You have unsaved changes. Do you want to save before exiting?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // discard
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // save
                  child: Text("Yes"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null), // cancel
                  child: Text("Cancel"),
                ),
              ],
            ),
      );

      if (result == true) {
        saveAndPop();
        return false; // handled manually
      } else if (result == false) {
        discardAndPop();
        return false;
      } else {
        return false; // cancel pressed
      }
    }

    discardAndPop(); // no changes, just pop
    return false;
  }

  void saveAndPop() {
    saveProfile();
    ref.read(tabIndexProvider.notifier).state = 3;
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('home');
    }
  }

  void discardAndPop() {
    ref.read(tabIndexProvider.notifier).state = 3;
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(personalDataProvider);
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    return state.when(
      loading: () => Center(child: _buildShimmerLoader()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (userData) {
        loadUserData(userData);
        return WillPopScope(
          onWillPop: onBackPressed,
          child: ScreenUtilInit(
            designSize: Size(375, 812),
            minTextAdapt: true,
            builder:
                (context, child) => Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        PersonalDataHeader(onBackPressed),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Stack(
                                    children: [
                                      CircleAvatar(radius: 45.r, child: Image.asset("assets/images/profile.png")),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: context.colors.primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: context.colors.defaultWhite, width: 1.w),
                                          ),
                                          padding: EdgeInsets.all(5.sp),
                                          child: Icon(Icons.camera_alt, size: 16.sp, color: context.colors.defaultWhite),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Text("Full Name", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                SizedBox(height: 8.h),
                                CustomFormField(
                                  hintText: "Full Name",
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
                                      return '⦿ Name is required';
                                    }
                                    if (value.length < 3) {
                                      return '⦿ Enter at least 3 characters';
                                    }
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
                                        final isSelected = selectedGender.toLowerCase() == gender.toLowerCase();
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
                                          },
                                        );
                                      }).toList(),
                                ),
                                SizedBox(height: 16.h),
                                Text("Phone", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                SizedBox(height: 8.h),
                                CustomFormField(
                                  controller: phoneController,
                                  focusNode: phoneNumberFocus,
                                  hintText: "Phone Number",
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
                                      return '⦿ Phone number is required';
                                    } else if (value.length < 10) {
                                      return '⦿ Enter a valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                Text("Email", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
                                SizedBox(height: 8.h),
                                CustomFormField(
                                  controller: emailController,
                                  focusNode: emailFocus,
                                  hintText: "Email ID",
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
                                      return '⦿ Email is required';
                                    }
                                    if (!emailRegex.hasMatch(value)) {
                                      return '⦿ Enter a valid email';
                                    }
                                    return null;
                                  },
                                  //label: "Email Address",
                                ),
                                SizedBox(height: 25.h),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: state.isLoading ? null : saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.colors.primary,
                                      padding: EdgeInsets.symmetric(vertical: 16.h),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                    ),
                                    child:
                                        state.isLoading
                                            ? const CircularProgressIndicator()
                                            : Text("Save", style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.defaultWhite)),
                                  ),
                                ),

                                SizedBox(height: 25.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(6, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: index == 0 ? 80 : 40,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)),
            );
          }),
        ),
      ),
    );
  }
}
