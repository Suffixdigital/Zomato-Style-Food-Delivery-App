import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral0, // background color
        borderRadius: BorderRadius.circular(20.r), // rounded corners
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral40,
            blurRadius: 5.r,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r), // rounded corners
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: AppColors.primaryAccent,
          unselectedItemColor: AppColors.neutral60,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryAccent,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            color: AppColors.neutral60,
          ),
          items:
              items.map((item) {
                return BottomNavigationBarItem(
                  icon: item.icon,
                  label: item.title,
                  activeIcon: item.icon,
                  backgroundColor: AppColors.neutral0,
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
