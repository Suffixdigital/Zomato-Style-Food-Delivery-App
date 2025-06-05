import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/screens/login_screen.dart';
import 'package:smart_flutter/screens/personal_data_screen.dart';
import 'package:smart_flutter/screens/settings_screen.dart';
import 'package:smart_flutter/viewmodels/profile_viewmodel.dart';
import 'package:smart_flutter/views/widgets/profile_screen/order_card.dart';
import 'package:smart_flutter/views/widgets/profile_screen/profile_header.dart';
import 'package:smart_flutter/views/widgets/profile_screen/profile_info.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;

    final orders = ref.watch(profileViewModelProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder:
          (context, child) => Scaffold(
            body: Column(
              children: [
                ProfileHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: 10.h,
                    ),
                    child: Column(
                      children: [
                        ProfileInfo(isTablet: isTablet),
                        SizedBox(height: 20.h),
                        ...orders.map(
                          (order) =>
                              OrderCard(isTablet: isTablet, order: order),
                        ),

                        Divider(height: 30.h, color: AppColors.neutral40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Profile',
                            style: AppTextTheme.fallback(isTablet: false)
                                .bodyMediumMedium!
                                .copyWith(color: AppColors.neutral60),
                            textAlign: TextAlign.start,
                          ),
                        ),

                        SizedBox(height: 15.h),
                        buildListTile(
                          "assets/icons/personal.svg",
                          "Personal Data",
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfileDataScreen(),
                              ),
                            );
                          },
                        ),
                        buildListTile(
                          "assets/icons/settings.svg",
                          "Settings",
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                        buildListTile(
                          "assets/icons/card.svg",
                          "Extra Card",
                          onPressed: () {},
                        ),
                        SizedBox(height: 5.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Support',
                            style: AppTextTheme.fallback(isTablet: false)
                                .bodyMediumMedium!
                                .copyWith(color: AppColors.neutral60),
                            textAlign: TextAlign.start,
                          ),
                        ),

                        SizedBox(height: 15.h),
                        buildListTile(
                          "assets/icons/info.svg",
                          "Help Center",
                          onPressed: () {},
                        ),
                        buildListTile(
                          "assets/icons/delete_account.svg",
                          "Request Account Deletion",
                          onPressed: () {},
                        ),
                        buildListTile(
                          "assets/icons/add_account.svg",
                          "Add another account",
                          onPressed: () {},
                        ),
                        SizedBox(height: 5.h),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.logout,
                              color: AppColors.errorBase,
                            ),
                            label: Text(
                              "Sign Out",
                              style: AppTextTheme.fallback(isTablet: false)
                                  .bodyMediumSemiBold!
                                  .copyWith(color: AppColors.errorBase),
                            ),
                            onPressed: () {
                              showSignOutDialog(context);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50.h),
                              side: BorderSide(color: AppColors.neutral40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 130.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget buildListTile(
    String path,
    String title, {
    required Function() onPressed,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              padding: EdgeInsets.all(6.sp),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
              ),
              child: SvgPicture.asset(path, width: 20.w, height: 20.h),
            ),
            SizedBox(width: 8.w),
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

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.neutral0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            title: Text(
              'Sign Out',
              textAlign: TextAlign.center,
              style: AppTextTheme.fallback(
                isTablet: false,
              ).headingH5SemiBold!.copyWith(color: AppColors.neutral100),
            ),
            content: Text(
              'Do you want to log out?',
              textAlign: TextAlign.center,
              style: AppTextTheme.fallback(
                isTablet: false,
              ).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: AppColors.neutral40, width: 1.0.w),
                  backgroundColor: AppColors.neutral0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.r)),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextTheme.fallback(
                    isTablet: false,
                  ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral100),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // Perform sign out logic here
                  handleSignOut(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.r)),
                  ),
                ),
                child: Text(
                  'Log Out',
                  style: AppTextTheme.fallback(
                    isTablet: false,
                  ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral0),
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceBetween,
          ),
    );
  }

  void handleSignOut(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Signed out successfully')));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) =>
                const LoginScreen(shouldForgotPasswordModelOnLoad: false),
      ),
    ); // Example route
  }
}
