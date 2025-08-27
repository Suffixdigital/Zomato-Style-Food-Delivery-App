import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class Style9BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final List<NavBarItem> items;

  const Style9BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background, // background color
        borderRadius: BorderRadius.circular(20.r), // rounded corners
        border: Border.all(
          color: context.colors.defaultGrayEEEEEE.withValues(alpha: 0.5),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.defaultGray878787,
            blurRadius: 3.r,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r), // rounded corners
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: context.colors.primary,
          unselectedItemColor: context.colors.defaultGray878787,
          selectedLabelStyle: textTheme.bodyMediumBold!.copyWith(
            color: context.colors.primary,
          ),
          unselectedLabelStyle: textTheme.bodyMediumBold!.copyWith(
            color: context.colors.defaultGray878787,
          ),
          items:
              items.map((item) {
                return BottomNavigationBarItem(
                  icon: item.icon,
                  label: item.title,
                  activeIcon: item.icon,
                  backgroundColor: context.colors.background,
                );
              }).toList(),
        ),
      ),
    );
  }
}

class NavBarItem {
  final Widget icon;
  final String title;

  NavBarItem({required this.icon, required this.title});
}
