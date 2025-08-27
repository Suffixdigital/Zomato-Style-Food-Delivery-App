import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/credit_card_model.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class CardListTile extends StatelessWidget {
  final CreditCardModel card;
  final bool isSelected;

  const CardListTile({super.key, required this.card, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:
              isSelected
                  ? context.colors.primary
                  : context.colors.defaultGrayEEEEEE,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isSelected
                    ? context.colors.primary.withValues(alpha: 0.4)
                    : context.colors.defaultGrayEEEEEE.withValues(alpha: 0.4),
            blurRadius: 2.r,
            spreadRadius: 2.r,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card_rounded, color: context.colors.generalText),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.brand,
                  style: textTheme.bodyMediumSemiBold!.copyWith(
                    color: context.colors.generalText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "**** **** **** ${card.last4Digits}",
                  style: textTheme.bodySmallRegular!.copyWith(
                    color: context.colors.defaultGray878787,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(card.logoAsset, height: 30.h, width: 40.w),
        ],
      ),
    );
  }
}
