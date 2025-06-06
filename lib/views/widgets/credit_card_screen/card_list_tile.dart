import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/credit_card_model.dart';

class CardListTile extends StatelessWidget {
  final CreditCardModel card;
  final bool isSelected;

  const CardListTile({super.key, required this.card, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.primaryAccent : Colors.transparent,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral30,
            blurRadius: 2.r,
            spreadRadius: 2.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.credit_card_rounded, color: AppColors.neutral100),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.brand,
                  style: AppTextTheme.fallback(
                    isTablet: false,
                  ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral100),
                ),
                SizedBox(height: 4.h),
                Text(
                  "**** **** **** ${card.last4Digits}",
                  style: AppTextTheme.fallback(
                    isTablet: false,
                  ).bodySmallRegular!.copyWith(color: AppColors.neutral60),
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
