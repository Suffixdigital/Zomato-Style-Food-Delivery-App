import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/order_model.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          BoxShadow(
            color: context.colors.defaultGrayEEEEEE.withValues(alpha: 0.5),
            spreadRadius: 2.r,
            blurRadius: 2.r,
            blurStyle: BlurStyle.solid,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Orders',
                style: textTheme.bodyLargeSemiBold!.copyWith(
                  color: context.colors.generalText,
                ),
              ),
              Text(
                'See All',
                style: textTheme.bodyMediumSemiBold!.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID ${order.orderId}',
                style: textTheme.bodyMediumRegular!.copyWith(
                  color: context.colors.generalText,
                ),
              ),
              Container(
                height: 26.h,
                width: 80.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'In Delivery',
                  style: textTheme.bodySuperSmallMedium!.copyWith(
                    color: context.colors.defaultWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: context.colors.defaultGray878787, height: 1.h),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(order.imageUrl, width: 50.w, height: 50.h),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    order.title,
                    style: textTheme.bodyMediumSemiBold!.copyWith(
                      color: context.colors.generalText,
                    ),
                  ),
                  Text(
                    '\$ ${order.price.toStringAsFixed(0)}',
                    style: textTheme.bodyMediumBold!.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                '${order.items} items',
                style: textTheme.bodyMediumSemiBold!.copyWith(
                  color: context.colors.generalText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
