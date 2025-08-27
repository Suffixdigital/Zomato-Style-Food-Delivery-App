import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/credit_card_model.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class CreditCardWidget extends StatelessWidget {
  final CreditCardModel card;

  const CreditCardWidget({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
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
                  style: textTheme.headingH6SemiBold!.copyWith(
                    color: context.colors.generalText,
                  ),
                ),
                Spacer(),
                Text(
                  "••• •••• •••• ${card.last4Digits}",
                  textScaler: TextScaler.linear(1.5),
                  style: textTheme.headingH5Medium!.copyWith(
                    color: context.colors.generalText,
                  ),
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
                          style: textTheme.bodySuperSmallRegular!.copyWith(
                            color: context.colors.generalText,
                          ),
                        ),
                        Text(
                          "•••• ••••",
                          textScaler: TextScaler.linear(1.5),
                          style: textTheme.bodyMediumMedium!.copyWith(
                            color: context.colors.generalText,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expiry date",
                          style: textTheme.bodySuperSmallRegular!.copyWith(
                            color: context.colors.generalText,
                          ),
                        ),
                        Text(
                          "•••/•••",
                          textScaler: TextScaler.linear(1.5),
                          style: textTheme.bodyMediumMedium!.copyWith(
                            color: context.colors.generalText,
                          ),
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
