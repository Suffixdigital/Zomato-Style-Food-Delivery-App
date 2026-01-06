import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/user_model.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/personal_data_viewmodel.dart';
import 'package:smart_flutter/viewmodels/profile_viewmodel.dart';
import 'package:smart_flutter/views/widgets/profile_screen/order_card.dart';
import 'package:smart_flutter/views/widgets/profile_screen/profile_header.dart';
import 'package:smart_flutter/views/widgets/profile_screen/profile_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late UserModel userData;

  void handleSignOut(BuildContext context) async {
    ref.read(tabIndexProvider.notifier).state = 0;
    await Supabase.instance.client.auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed out successfully')));
    context.goNamed('login');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    final userAsync = ref.watch(personalDataProvider);

    final orders = ref.watch(profileViewModelProvider);

    return userAsync.when(
      loading: () => _buildShimmerLoader(),
      error: (err, stack) => Text('Error: $err'),
      data: (userData) {
        return ScreenUtilInit(
          designSize: Size(375, 812),
          minTextAdapt: true,
          builder:
              (context, child) => Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      ProfileHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
                          child: Column(
                            children: [
                              ProfileInfo(userData: userData),
                              SizedBox(height: 20.h),
                              ...orders.map((order) => OrderCard(order: order)),

                              Divider(height: 30.h, color: context.colors.defaultGray878787),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Profile',
                                  style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              SizedBox(height: 15.h),
                              buildListTile(
                                "assets/icons/personal.svg",
                                "Personal Data",
                                onPressed: () {
                                  context.pushNamed('profileData');
                                },
                              ),
                              buildListTile(
                                "assets/icons/settings.svg",
                                "Settings",
                                onPressed: () {
                                  context.pushNamed('settings');
                                },
                              ),
                              buildListTile(
                                "assets/icons/card.svg",
                                "Extra Card",
                                onPressed: () {
                                  context.pushNamed('credit_card');
                                },
                              ),
                              SizedBox(height: 5.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Support',
                                  style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              SizedBox(height: 15.h),
                              buildListTile("assets/icons/info.svg", "Help Center", onPressed: () {}),
                              buildListTile("assets/icons/delete_account.svg", "Request Account Deletion", onPressed: () {}),
                              buildListTile("assets/icons/add_account.svg", "Add another account", onPressed: () {}),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  icon: Icon(Icons.logout, color: context.colors.error),
                                  label: Text("Sign Out", style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.error)),
                                  onPressed: () {
                                    showSignOutDialog(textTheme, context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50.h),
                                    side: BorderSide(color: context.colors.defaultGrayEEEEEE),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.r))),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }

  Widget buildListTile(String path, String title, {required Function() onPressed}) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
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
              decoration: BoxDecoration(color: context.colors.defaultGrayEEEEEE.withValues(alpha: 0.6), borderRadius: BorderRadius.all(Radius.circular(10.r))),
              child: SvgPicture.asset(path, width: 20.w, height: 20.h, colorFilter: ColorFilter.mode(context.colors.generalText, BlendMode.srcIn)),
            ),
            SizedBox(width: 8.w),
            Text(title, style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.generalText)),
            Spacer(),
            SvgPicture.asset('assets/icons/next.svg', width: 16.w, height: 16.h, colorFilter: ColorFilter.mode(context.colors.generalText, BlendMode.srcIn)),
          ],
        ),
      ),
    );
  }

  void showSignOutDialog(AppTextTheme textTheme, BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: context.colors.background,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: context.colors.defaultGrayEEEEEE.withValues(alpha: 0.6), width: 1.0.w),
              borderRadius: BorderRadius.circular(10.r),
            ),
            title: Text('Sign Out', textAlign: TextAlign.center, style: textTheme.headingH5SemiBold!.copyWith(color: context.colors.generalText)),
            content: Text(
              'Do you want to log out?',
              textAlign: TextAlign.center,
              style: AppTextTheme.fallback(isTablet: false).bodyMediumMedium!.copyWith(color: context.colors.defaultGray878787),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: context.colors.defaultGrayEEEEEE.withValues(alpha: 0.6), width: 1.0.w),
                  backgroundColor: context.colors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.r))),
                ),
                child: Text('Cancel', style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.generalText)),
              ),
              ElevatedButton(
                onPressed: () {
                  handleSignOut(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.r))),
                ),
                child: Text('Log Out', style: AppTextTheme.fallback(isTablet: false).bodyMediumSemiBold!.copyWith(color: context.colors.defaultWhite)),
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceBetween,
          ),
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
