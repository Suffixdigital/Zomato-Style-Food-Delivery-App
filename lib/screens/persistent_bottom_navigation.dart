import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/screens/cart_screen.dart';
import 'package:smart_flutter/screens/chat_screen.dart';
import 'package:smart_flutter/screens/home_screen.dart';
import 'package:smart_flutter/screens/profile_screen.dart';

import '../routes/tab_controller_notifier.dart';

class PersistentBottomNavigation extends ConsumerStatefulWidget {
  const PersistentBottomNavigation({super.key});

  @override
  ConsumerState<PersistentBottomNavigation> createState() =>
      _PersistentBottomNavigationState();
}

class _PersistentBottomNavigationState
    extends ConsumerState<PersistentBottomNavigation> {
  DateTime? lastBackPressTime;

  List<PersistentTabConfig> _tabs() => [
    PersistentTabConfig(
      screen: const HomeScreen(),
      item: ItemConfig(
        icon: SvgPicture.asset(
          "assets/icons/home.svg",
          colorFilter: ColorFilter.mode(
            AppColors.primaryAccent,
            BlendMode.srcIn,
          ),
        ),
        title: "Home",
        inactiveIcon: SvgPicture.asset("assets/icons/home.svg"),
        activeForegroundColor: AppColors.primaryAccent,
        inactiveForegroundColor: AppColors.neutral60,
      ),
    ),
    PersistentTabConfig(
      screen: const CartScreen(),
      item: ItemConfig(
        icon: SvgPicture.asset(
          "assets/icons/cart.svg",
          colorFilter: ColorFilter.mode(
            AppColors.primaryAccent,
            BlendMode.srcIn,
          ),
        ),
        title: "Cart",
        inactiveIcon: SvgPicture.asset("assets/icons/cart.svg"),
        activeForegroundColor: AppColors.primaryAccent,
        inactiveForegroundColor: AppColors.neutral60,
      ),
    ),
    PersistentTabConfig(
      screen: const ChatScreen(),
      item: ItemConfig(
        icon: SvgPicture.asset(
          "assets/icons/chat.svg",
          colorFilter: ColorFilter.mode(
            AppColors.primaryAccent,
            BlendMode.srcIn,
          ),
        ),
        title: "Chat",
        inactiveIcon: SvgPicture.asset("assets/icons/chat.svg"),
        activeForegroundColor: AppColors.primaryAccent,
        inactiveForegroundColor: AppColors.neutral60,
      ),
    ),
    PersistentTabConfig(
      screen: const ProfileScreen(),
      item: ItemConfig(
        icon: SvgPicture.asset(
          "assets/icons/profile.svg",
          colorFilter: ColorFilter.mode(
            AppColors.primaryAccent,
            BlendMode.srcIn,
          ),
        ),
        title: "Profile",
        inactiveIcon: SvgPicture.asset("assets/icons/profile.svg"),
        activeForegroundColor: AppColors.primaryAccent,
        inactiveForegroundColor: AppColors.neutral60,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(persistentTabController);

    return WillPopScope(
      onWillPop: () async {
        final currentIndex = controller.index;

        // If not on Home tab (index 0), go to Home
        if (currentIndex != 0) {
          controller.jumpToTab(0);
          return false;
        }

        // Already on Home tab, handle exit with double back
        final now = DateTime.now();
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          lastBackPressTime = now;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back again to exit')),
          );
          return false;
        }

        return true; // Exit app
      },
      child: PersistentTabView(
        controller: controller,
        tabs: _tabs(),
        navBarHeight: 60.h,
        navBarBuilder:
            (navBarConfig) => Style9BottomNavBar(
              navBarConfig: navBarConfig,
              navBarDecoration: NavBarDecoration(
                color: AppColors.neutral0,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neutral40,
                    blurRadius: 5.r,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              itemAnimationProperties: const ItemAnimation(),
            ),
        avoidBottomPadding: true,
        handleAndroidBackButtonPress: false,
        // must be false to delegate to WillPopScope
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBar: false,
        popAllScreensOnTapOfSelectedTab: true,
      ),
    );
  }
}
