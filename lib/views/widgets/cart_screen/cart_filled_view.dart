import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/data/dummy_data.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/viewmodels/cart_viewmodel.dart';

class CartFilledView extends ConsumerWidget {
  final bool isTablet;

  const CartFilledView({required this.isTablet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current cart state
    final cartState = ref.watch(cartViewModelProvider);
    // Get notifier for calling methods
    final cartVM = ref.read(cartViewModelProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Location',
                    style: AppTextTheme.fallback(
                      isTablet: isTablet,
                    ).bodyMediumRegular!.copyWith(color: AppColors.neutral60),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Home',
                    style: AppTextTheme.fallback(
                      isTablet: isTablet,
                    ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral100),
                  ),
                ],
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  minimumSize: Size(120.w, 30.h),
                ),
                onPressed: () {},

                child: Text(
                  'Change Location',
                  style: AppTextTheme.fallback(isTablet: isTablet)
                      .bodySuperSmallMedium!
                      .copyWith(color: AppColors.primaryAccent),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Promo Code Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutral30),
              color: AppColors.neutral0,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 4.w),
                SvgPicture.asset("assets/icons/promo_icon.svg"),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Promo Code...',
                      hintStyle: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumMedium!.copyWith(color: AppColors.neutral50),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    minimumSize: Size(60.w, 35.h),
                  ),
                  child: Text(
                    'Apply',
                    style: AppTextTheme.fallback(
                      isTablet: isTablet,
                    ).bodySmallSemiBold!.copyWith(color: AppColors.neutral0),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 15.h),

          /// Cart Items List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartState.items.length,
            itemBuilder: (context, index) {
              final item = cartState.items[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.neutral0,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral40,
                      blurRadius: 4.r,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Row(
                  children: [
                    /// Checkbox
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Icon(
                        Icons.check_box_rounded,
                        color: AppColors.primaryAccent,
                        size: 24.sp,
                      ),
                    ),

                    /// Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        item.imageUrl,
                        height: 80.h,
                        width: 90.w,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    /// Title + Price + Quantity
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.fallback(isTablet: isTablet)
                                .bodyLargeSemiBold!
                                .copyWith(color: AppColors.neutral100),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '\$ ${item.price.toStringAsFixed(0)}',
                            style: AppTextTheme.fallback(isTablet: isTablet)
                                .bodyMediumBold!
                                .copyWith(color: AppColors.primaryAccent),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (item.quantity > 1) {
                                        cartVM.decreaseQty(item.id);
                                      }
                                    },
                                    child: DeviceUtils.backIcon(
                                      "assets/icons/minus.svg",
                                      item.quantity > 1
                                          ? AppColors.neutral100
                                          : AppColors.neutral60,
                                      14,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    item.quantity.toString(),
                                    style: AppTextTheme.fallback(
                                      isTablet: false,
                                    ).bodyMediumMedium!.copyWith(
                                      color: AppColors.neutral100,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () {
                                      cartVM.increaseQty(item.id);
                                    },
                                    child: DeviceUtils.backIcon(
                                      "assets/icons/plus.svg",
                                      AppColors.neutral100,
                                      14,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  cartVM.removeItem(item.id);
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/delete.svg",
                                  width: 20.w,
                                  height: 20.w,
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
            },
          ),

          SizedBox(height: 25.h),

          /// Recommendations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recommended For You",
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyLargeSemiBold!.copyWith(color: AppColors.neutral100),
              ),
              Text(
                "See All",
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyMediumMedium!.copyWith(color: AppColors.primaryAccent),
              ),
            ],
          ),
          SizedBox(height: 15.h),

          SizedBox(
            height: 190.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final food = foodItems[index];
                return GestureDetector(
                  onTap: () => cartVM.addItemFromFood(food),
                  child: Container(
                    width: 130.w,
                    margin: EdgeInsets.only(
                      left: 1.w,
                      right: 12.w,
                      top: 2.h,
                      bottom: 2.h,
                    ),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.neutral0,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(color: AppColors.neutral40, blurRadius: 1.r),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: Image.asset(
                            food.imageUrl,
                            height: 100.h,
                            width: 130.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          food.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.fallback(isTablet: isTablet)
                              .bodyLargeMedium!
                              .copyWith(color: AppColors.neutral100),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/star.svg"),
                                SizedBox(width: 2.w),
                                Text(
                                  "${food.rating}",
                                  style: AppTextTheme.fallback(
                                    isTablet: isTablet,
                                  ).bodySmallMedium!.copyWith(
                                    color: AppColors.neutral100,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/location_on.svg",
                                  colorFilter: ColorFilter.mode(
                                    AppColors.primaryAccent,
                                    BlendMode.srcIn,
                                  ),
                                  width: 10.w,
                                  height: 10.h,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "${food.distance}m",
                                  style: AppTextTheme.fallback(
                                    isTablet: isTablet,
                                  ).bodySmallMedium!.copyWith(
                                    color: AppColors.neutral100,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "\$${food.price.toStringAsFixed(0)}",
                          style: AppTextTheme.fallback(isTablet: isTablet)
                              .bodyLargeBold!
                              .copyWith(color: AppColors.primaryAccent),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 15.h),

          Divider(height: 1.5.h, color: AppColors.neutral30),

          SizedBox(height: 15.h),

          /// Payment Summary
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.neutral0,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.neutral30, width: 1.w),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Summary",
                  style: AppTextTheme.fallback(
                    isTablet: isTablet,
                  ).bodyLargeSemiBold!.copyWith(color: AppColors.neutral800),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Items (${cartState.items.length})",
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
                    ),
                    Text(
                      "\$${cartState.totalPrice.toStringAsFixed(0)}",
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumBold!.copyWith(color: AppColors.neutral800),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delivery Fee",
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
                    ),
                    Text(
                      "Free",
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumBold!.copyWith(color: AppColors.neutral800),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Discount",
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
                    ),
                    Text(
                      "-\$${cartState.discount.toStringAsFixed(0)}",
                      style: AppTextTheme.fallback(isTablet: isTablet)
                          .bodyMediumBold!
                          .copyWith(color: AppColors.primaryAccent),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
                    ),
                    Text(
                      "\$${cartState.total.toStringAsFixed(0)}",
                      style: AppTextTheme.fallback(
                        isTablet: isTablet,
                      ).bodyMediumBold!.copyWith(color: AppColors.neutral800),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                "Order Now",
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral0),
              ),
            ),
          ),

          SizedBox(height: 25.h),
        ],
      ),
    );
  }
}
