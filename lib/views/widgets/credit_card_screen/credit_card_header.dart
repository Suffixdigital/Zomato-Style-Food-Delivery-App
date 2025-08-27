import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class CreditCardHeader extends ConsumerWidget {
  final Future<bool> Function() onBackPressed;

  const CreditCardHeader({super.key, required this.onBackPressed});

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
              onPressed: onBackPressed,
            ),
          ),

          Text(
            'Extra Card',
            style: textTheme.bodyLargeSemiBold!.copyWith(
              color: context.colors.generalText,
            ),
          ),
        ],
      ),
    );
  }
}
