import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isTablet = false;

  const OrderCard({super.key, required this.order, required bool isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral20,
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
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyLargeSemiBold!.copyWith(color: AppColors.neutral100),
              ),
              Text(
                'See All',
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyMediumSemiBold!.copyWith(color: AppColors.primaryAccent),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order ID ${order.orderId}'),
              Container(
                height: 26.h,
                width: 80.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'In Delivery',
                  style: AppTextTheme.fallback(
                    isTablet: isTablet,
                  ).bodySuperSmallMedium!.copyWith(color: AppColors.neutral0),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: AppColors.neutral20, height: 1.h),
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
                    style: AppTextTheme.fallback(
                      isTablet: isTablet,
                    ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral100),
                  ),
                  Text(
                    '\$ ${order.price.toStringAsFixed(0)}',
                    style: AppTextTheme.fallback(
                      isTablet: isTablet,
                    ).bodyMediumBold!.copyWith(color: AppColors.primaryAccent),
                  ),
                ],
              ),
              Spacer(),
              Text(
                '${order.items} items',
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral100),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
