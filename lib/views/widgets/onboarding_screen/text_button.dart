import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_styles.dart';

class TextIconButton extends StatelessWidget {
  const TextIconButton({
    super.key,
    required this.textLabel,
    required this.onPressed,
  });

  final String textLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    return TextButton(
      onPressed: onPressed,
      child:
          textLabel == "Next"
              ? Row(
                children: [
                  Text(
                    textLabel,
                    style: AppTextTheme.fallback(
                      isTablet: isTablet,
                    ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral0),
                  ),
                  SizedBox(width: 10.w),
                  SvgPicture.asset(
                    'assets/icons/arrow-forword.svg',
                    width: isTablet ? 16.w : 10.w,
                    height: isTablet ? 16.h : 10.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.neutral0,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              )
              : Center(
                child: Text(
                  textLabel,
                  style: AppTextStyles.buttonText(isTablet),
                ),
              ),
    );
  }
}
