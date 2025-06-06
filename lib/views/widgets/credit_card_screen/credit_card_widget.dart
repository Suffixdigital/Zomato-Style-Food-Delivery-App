import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/credit_card_model.dart';

class CreditCardWidget extends StatelessWidget {
  final CreditCardModel card;
  final bool isTablet;

  CreditCardWidget({required this.card, super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      height: 190.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                image: AssetImage('assets/images/creditcard_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  card.brand,
                  style: AppTextTheme.fallback(
                    isTablet: isTablet,
                  ).headingH6SemiBold!.copyWith(color: AppColors.neutral0),
                ),
                Spacer(),
                Text(
                  "••• •••• •••• ${card.last4Digits}",
                  textScaler: TextScaler.linear(1.5),
                  style: AppTextTheme.fallback(
                    isTablet: isTablet,
                  ).headingH5Medium!.copyWith(color: AppColors.neutral0),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Card holder name",
                          style: AppTextTheme.fallback(isTablet: isTablet)
                              .bodySuperSmallRegular!
                              .copyWith(color: AppColors.neutral0),
                        ),
                        Text(
                          "•••• ••••",
                          textScaler: TextScaler.linear(1.5),
                          style: AppTextTheme.fallback(isTablet: isTablet)
                              .bodyMediumMedium!
                              .copyWith(color: AppColors.neutral0),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expiry date",
                          style: AppTextTheme.fallback(isTablet: isTablet)
                              .bodySuperSmallRegular!
                              .copyWith(color: AppColors.neutral0),
                        ),
                        Text(
                          "•••/•••",
                          textScaler: TextScaler.linear(1.5),
                          style: AppTextTheme.fallback(isTablet: isTablet)
                              .bodyMediumMedium!
                              .copyWith(color: AppColors.neutral0),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Image.asset(
                        card.logoAsset,
                        height: 60.h,
                        width: 60.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
