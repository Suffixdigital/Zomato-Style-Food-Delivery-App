import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/user_model.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/viewmodels/personal_data_viewmodel.dart';
import 'package:smart_flutter/views/widgets/login_screen/custom_text_field.dart';
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

  late String initialFullName,
      initialDob,
      initialPhone,
      initialEmail,
      initialGender;

  final genderOptions = ['Male', 'Female'];
  String selectedGender = 'Male';

  @override
  void initState() {
    final user = ref.read(personalDataProvider).user;
    fullNameController = TextEditingController(text: user.fullName);
    dobController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(user.dateOfBirth),
    );
    phoneController = TextEditingController(text: user.phone);
    emailController = TextEditingController(text: user.email);
    selectedGender = user.gender;

    initialFullName = fullNameController.text;
    initialDob = dobController.text;
    initialPhone = phoneController.text;
    initialEmail = emailController.text;
    initialGender = selectedGender;
    super.initState();
  }

  bool get hasChanges {
    return fullNameController.text != initialFullName ||
        dobController.text != initialDob ||
        phoneController.text != initialPhone ||
        emailController.text != initialEmail ||
        selectedGender != initialGender;
  }

  void saveProfile() {
    final viewModel = ref.read(personalDataProvider);
    viewModel.updateUser(
      UserModel(
        fullName: fullNameController.text,
        dateOfBirth: DateFormat('dd/MM/yyyy').parse(dobController.text),
        gender: selectedGender,
        phone: phoneController.text,
        email: emailController.text,
      ),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profile Saved")));
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy').parse(dobController.text),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<bool> onBackPressed() async {
    if (hasChanges) {
      final result = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Save Changes?"),
              content: const Text(
                "You have unsaved changes. Do you want to save before exiting?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // discard
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // save
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null), // cancel
                  child: const Text("Cancel"),
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
    ref.read(persistentTabController).jumpToTab(3);
    Navigator.of(context).pop();
  }

  void discardAndPop() {
    ref.read(persistentTabController).jumpToTab(3);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;

    return WillPopScope(
      onWillPop: onBackPressed,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
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
                                  CircleAvatar(
                                    radius: 45.r,
                                    child: Image.asset(
                                      "assets/images/profile.png",
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.w,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(5.sp),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Full Name",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            CustomTextField(
                              controller: fullNameController,
                              hintText: "Full Name",
                              keyboardType: TextInputType.name,
                              onTap: () {},
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "Date of birth",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            CustomTextField(
                              controller: dobController,
                              hintText: "Date of Birth",
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              onTap: selectDate,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "Gender",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            DropdownButtonFormField<String>(
                              value: selectedGender,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items:
                                  genderOptions.map((gender) {
                                    return DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => selectedGender = value!),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "Phone",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            CustomTextField(
                              controller: phoneController,
                              hintText: "Phone",
                              keyboardType: TextInputType.phone,
                              onTap: () {},
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "Email",
                              style: AppTextTheme.fallback(isTablet: isTablet)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral100),
                            ),
                            SizedBox(height: 8.h),
                            CustomTextField(
                              controller: emailController,
                              hintText: "Email",
                              keyboardType: TextInputType.emailAddress,
                              onTap: () {},
                            ),
                            SizedBox(height: 25.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => saveProfile(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                                child: Text(
                                  "Save",
                                  style: AppTextTheme.fallback(
                                    isTablet: isTablet,
                                  ).bodyMediumSemiBold!.copyWith(
                                    color: AppColors.neutral0,
                                  ),
                                ),
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
  }
}
