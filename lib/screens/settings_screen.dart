import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/data/language_details.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/theme/app_colors.dart';
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
    ref.read(tabIndexProvider.notifier).state = 3;
    context.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(settingsViewModelProvider);
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
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
                    SettingsHeader(onBackPressed),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'General',
                              style: textTheme.bodyMediumMedium!.copyWith(
                                color: context.colors.defaultGray878787,
                              ),
                              textAlign: TextAlign.start,
                            ),

                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Dark Mode",
                                  style: textTheme.bodyMediumMedium!.copyWith(
                                    color: context.colors.generalText,
                                  ),
                                ),
                                Transform.scale(
                                  alignment: Alignment.centerRight,
                                  scale: 0.9,
                                  child: customSwitch(
                                    value: vm.isDarkMode,
                                    onChanged: (val) {
                                      setState(
                                        () => ref
                                            .read(
                                              settingsViewModelProvider
                                                  .notifier,
                                            )
                                            .updateDarkMode(val),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Push Notification",
                                  style: textTheme.bodyMediumMedium!.copyWith(
                                    color: context.colors.generalText,
                                  ),
                                ),
                                Transform.scale(
                                  alignment: Alignment.centerRight,
                                  scale: 0.9,
                                  child: customSwitch(
                                    value: vm.pushNotification,
                                    onChanged: (val) {
                                      setState(
                                        () => ref
                                            .read(
                                              settingsViewModelProvider
                                                  .notifier,
                                            )
                                            .updatePushNotification(val),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Location",
                                  style: textTheme.bodyMediumMedium!.copyWith(
                                    color: context.colors.generalText,
                                  ),
                                ),
                                Transform.scale(
                                  alignment: Alignment.centerRight,
                                  scale: 0.9,
                                  child: customSwitch(
                                    value: vm.locationEnabled,
                                    onChanged: (val) {
                                      setState(
                                        () => ref
                                            .read(
                                              settingsViewModelProvider
                                                  .notifier,
                                            )
                                            .updateLocation(val),
                                      );
                                    },
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
                                      style: textTheme.bodyMediumMedium!
                                          .copyWith(
                                            color: context.colors.generalText,
                                          ),
                                    ),
                                    Spacer(),
                                    Text(
                                      languageDetails[vm
                                          .languageIndex]['selectedLanguage'],
                                      style: textTheme.bodyMediumMedium!
                                          .copyWith(
                                            color: context.colors.generalText,
                                          ),
                                    ),
                                    SizedBox(width: 20.w),
                                    SvgPicture.asset(
                                      colorFilter: ColorFilter.mode(
                                        context.colors.generalText,
                                        BlendMode.srcIn,
                                      ),
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
                              style: textTheme.bodyMediumMedium!.copyWith(
                                color: context.colors.defaultGray878787,
                              ),
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
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.bodyMediumMedium!.copyWith(
                color: context.colors.generalText,
              ),
            ),
            Spacer(),
            SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                context.colors.generalText,
                BlendMode.srcIn,
              ),
              'assets/icons/next.svg',
              width: 16.w,
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget customSwitch({
    required bool value,
    required Function(dynamic val) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 58.w,
        height: 30.h,
        padding: EdgeInsets.all(2.5.w),
        decoration: BoxDecoration(
          color: value ? context.colors.primary : context.colors.background,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color:
                value
                    ? context.colors.primary
                    : context.colors.defaultGray878787.withOpacity(0.5),
            width: 1.2.w,
          ),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 25.w,
          height: 25.h,
          decoration: BoxDecoration(
            color:
                value
                    ? context.colors.defaultWhite
                    : context.colors.defaultGray878787,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
