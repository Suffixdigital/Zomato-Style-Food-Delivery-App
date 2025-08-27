import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
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
                context.colors.generalText,
                16,
              ),
              onPressed: () {
                ref.read(tabIndexProvider.notifier).state = 0;

                // Go to home screen
                context.goNamed('home');
              },
            ),
          ),

          Text(
            'Profile Settings',
            style: textTheme.bodyLargeSemiBold!.copyWith(
              color: context.colors.generalText,
            ),
          ),
        ],
      ),
    );
  }
}
