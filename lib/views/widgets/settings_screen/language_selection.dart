import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/data/language_details.dart';
import 'package:smart_flutter/theme/app_colors.dart';
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
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Scaffold(
      backgroundColor: context.colors.defaultBlack.withValues(alpha: 0.5),
      // Blurred background illusion
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: context.colors.background,
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
                    color: context.colors.defaultGray878787,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Select Language",
                style: textTheme.bodyLargeSemiBold!.copyWith(
                  color: context.colors.generalText,
                ),
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
                                ? context.colors.primary
                                : context.colors.defaultGray878787,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      color:
                          isSelected
                              ? context.colors.primary.withValues(alpha: 0.04)
                              : context.colors.background,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: context.colors.defaultGrayEEEEEE
                              .withValues(alpha: 0.5),
                          radius: 16.r,
                          child: Image.asset(
                            option['icon'].toString(),
                            width: 18.w,
                            height: 18.h,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['language'].toString(),
                                style: textTheme.bodyMediumSemiBold!.copyWith(
                                  color: context.colors.generalText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: context.colors.primary,
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
                        .updateLanguage(selectedIndex);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Select",
                    style: textTheme.bodyMediumSemiBold!.copyWith(
                      color: context.colors.defaultWhite,
                    ),
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
