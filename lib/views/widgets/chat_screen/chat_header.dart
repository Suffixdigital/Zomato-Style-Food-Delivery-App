import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';

class ChatHeader extends ConsumerWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: DeviceUtils.backIcon(
                'assets/icons/back.svg',
                AppColors.neutral100,
                16,
              ),
              onPressed: () => ref.read(persistentTabController).jumpToTab(0),
            ),
          ),

          Text(
            'Chat List',
            style: AppTextTheme.fallback(
              isTablet: false,
            ).bodyLargeSemiBold!.copyWith(color: AppColors.neutral100),
          ),
        ],
      ),
    );
  }
}
