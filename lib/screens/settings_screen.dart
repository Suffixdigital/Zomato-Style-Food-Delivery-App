import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/data/language_details.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/viewmodels/settings_viewmodel.dart';
import 'package:smart_flutter/views/widgets/settings_screen/language_selection.dart';
import 'package:smart_flutter/views/widgets/settings_screen/settings_header.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<bool> onBackPressed() async {
    ref.read(persistentTabController).jumpToTab(3);
    Navigator.of(context).pop(); // no changes, just pop
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    final vm = ref.watch(settingsViewModelProvider);

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
                    SettingsHeader(onBackPressed),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'General',
                              style: AppTextTheme.fallback(isTablet: false)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral60),
                              textAlign: TextAlign.start,
                            ),

                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Push Notification",
                                  style: AppTextTheme.fallback(isTablet: false)
                                      .bodyMediumMedium!
                                      .copyWith(color: AppColors.neutral100),
                                ),
                                Transform.scale(
                                  alignment: Alignment.centerRight,
                                  scale: 0.7,
                                  child: Switch(
                                    value: vm.pushNotification,
                                    onChanged:
                                        (val) => ref
                                            .read(
                                              settingsViewModelProvider
                                                  .notifier,
                                            )
                                            .togglePushNotification(val),
                                    activeColor: AppColors.neutral0,
                                    activeTrackColor: AppColors.primaryAccent,
                                    inactiveTrackColor: AppColors.primaryColor,
                                    inactiveThumbColor: AppColors.neutral0,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    trackOutlineColor:
                                        MaterialStateProperty.all(
                                          Colors.transparent,
                                        ),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Location",
                                  style: AppTextTheme.fallback(isTablet: false)
                                      .bodyMediumMedium!
                                      .copyWith(color: AppColors.neutral100),
                                ),
                                Transform.scale(
                                  alignment: Alignment.centerRight,
                                  scale: 0.7,
                                  child: Switch(
                                    value: vm.locationEnabled,
                                    onChanged:
                                        (val) => ref
                                            .read(
                                              settingsViewModelProvider
                                                  .notifier,
                                            )
                                            .toggleLocation(val),
                                    activeColor: AppColors.neutral0,
                                    activeTrackColor: AppColors.primaryAccent,
                                    inactiveTrackColor: AppColors.primaryColor,
                                    inactiveThumbColor: AppColors.neutral0,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    trackOutlineColor:
                                        MaterialStateProperty.all(
                                          Colors.transparent,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              margin: EdgeInsets.only(bottom: 20.h),
                              child: GestureDetector(
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => LanguageSelection(),
                                    );
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Language",
                                      style: AppTextTheme.fallback(
                                        isTablet: false,
                                      ).bodyMediumMedium!.copyWith(
                                        color: AppColors.neutral100,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      languageDetails[vm
                                          .languageIndex]['selectedLanguage'],
                                      style: AppTextTheme.fallback(
                                        isTablet: false,
                                      ).bodyMediumMedium!.copyWith(
                                        color: AppColors.neutral100,
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                    SvgPicture.asset(
                                      'assets/icons/next.svg',
                                      width: 16.w,
                                      height: 16.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Other',
                              style: AppTextTheme.fallback(isTablet: false)
                                  .bodyMediumMedium!
                                  .copyWith(color: AppColors.neutral60),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 15.h),
                            buildListTile("About Smart Food", onPressed: () {}),
                            buildListTile("Privacy Policy", onPressed: () {}),
                            buildListTile(
                              "Terms and Conditions",
                              onPressed: () {},
                            ),
                            SizedBox(height: 15.h),
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

  Widget buildListTile(String title, {required Function() onPressed}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextTheme.fallback(
                isTablet: false,
              ).bodyMediumMedium!.copyWith(color: AppColors.neutral100),
            ),
            Spacer(),
            SvgPicture.asset(
              'assets/icons/next.svg',
              width: 16.w,
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
