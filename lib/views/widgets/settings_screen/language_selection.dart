import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/data/language_details.dart';
import 'package:smart_flutter/viewmodels/settings_viewmodel.dart';

class LanguageSelection extends ConsumerStatefulWidget {
  const LanguageSelection({super.key});

  @override
  ConsumerState<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends ConsumerState<LanguageSelection> {
  int selectedIndex = 0;

  void onOptionTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    final vm = ref.read(settingsViewModelProvider);
    selectedIndex = vm.languageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppColors.neutral100.withValues(alpha: 0.5),
      // Blurred background illusion
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AppColors.neutral0,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.neutral40,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Select Language",
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyLargeSemiBold!.copyWith(color: AppColors.neutral100),
              ),
              SizedBox(height: 24.h),

              // Options
              ...List.generate(languageDetails.length, (index) {
                final isSelected = selectedIndex == index;
                final option = languageDetails[index];

                return GestureDetector(
                  onTap: () => onOptionTap(index),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryAccent
                                : AppColors.neutral30,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      color:
                          isSelected
                              ? AppColors.primaryAccent.withValues(alpha: 0.04)
                              : AppColors.neutral0,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.neutral30,
                          radius: 16.r,
                          child: Image.asset(
                            option['icon'].toString(),
                            width: 14.w,
                            height: 14.h,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['language'].toString(),
                                style: AppTextTheme.fallback(isTablet: isTablet)
                                    .bodyMediumSemiBold!
                                    .copyWith(color: AppColors.neutral100),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primaryAccent,
                            size: 24.sp,
                          ),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(settingsViewModelProvider.notifier)
                        .selectLanguage(selectedIndex);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Select",
                    style: AppTextTheme.fallback(
                      isTablet: isTablet,
                    ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral0),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
