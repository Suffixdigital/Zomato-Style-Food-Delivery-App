import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/cart_viewmodel.dart';

class CartFilledView extends ConsumerWidget {
  const CartFilledView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current cart state
    final cartState = ref.watch(cartViewModelProvider);
    // Get notifier for calling methods
    final cartVM = ref.read(cartViewModelProvider.notifier);
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    print("cartState.categoryIds : ${cartState.categoryIds.length}");
    final relatedItemsAsync = ref.watch(
      relatedItemsProviders(cartState.categoryIds),
    );

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
                    style: textTheme.bodyMediumRegular!.copyWith(
                      color: context.colors.defaultGray878787,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Home',
                    style: textTheme.bodyMediumSemiBold!.copyWith(
                      color: context.colors.generalText,
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.colors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  minimumSize: Size(120.w, 30.h),
                ),
                onPressed: () {},

                child: Text(
                  'Change Location',
                  style: textTheme.bodySuperSmallMedium!.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Promo Code Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colors.defaultGray878787,
                width: 1.w,
              ),
              color: context.colors.background,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 4.w),
                SvgPicture.asset(
                  "assets/icons/promo_icon.svg",
                  colorFilter: ColorFilter.mode(
                    context.colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Promo Code...',
                      hintStyle: textTheme.bodyMediumMedium!.copyWith(
                        color: context.colors.defaultGray878787,
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: context.colors.background,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    minimumSize: Size(60.w, 35.h),
                  ),
                  child: Text(
                    'Apply',
                    style: textTheme.bodySmallSemiBold!.copyWith(
                      color: context.colors.defaultWhite,
                    ),
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
                  color: context.colors.background,
                  border: Border.all(
                    color: context.colors.defaultGrayEEEEEE,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.defaultGrayEEEEEE,
                      blurRadius: 2.r,
                      spreadRadius: 0.5.r,
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
                        Icons.check_circle_outlined,
                        color: context.colors.primary,
                        size: 24.sp,
                      ),
                    ),

                    /// Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
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
                            style: textTheme.bodyLargeSemiBold!.copyWith(
                              color: context.colors.generalText,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '\$ ${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: textTheme.bodyMediumBold!.copyWith(
                              color: context.colors.primary,
                            ),
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
                                          ? context.colors.generalText
                                          : context.colors.defaultGray878787,
                                      14,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    item.quantity.toString(),
                                    style: AppTextTheme.fallback(
                                      isTablet: false,
                                    ).bodyMediumMedium!.copyWith(
                                      color: context.colors.generalText,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () {
                                      cartVM.increaseQty(item.id);
                                    },
                                    child: DeviceUtils.backIcon(
                                      "assets/icons/plus.svg",
                                      context.colors.generalText,
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
                                  colorFilter: ColorFilter.mode(
                                    context.colors.error,
                                    BlendMode.srcIn,
                                  ),
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
                style: textTheme.bodyLargeSemiBold!.copyWith(
                  color: context.colors.generalText,
                ),
              ),
              Text(
                "See All",
                style: textTheme.bodyMediumMedium!.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),

          relatedItemsAsync.when(
            error: (err, stack) => Center(child: Text('Error: $err')),
            loading: () => Center(child: CircularProgressIndicator()),
            data:
                (categoryItems) => SizedBox(
                  height: 192.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryItems.length,
                    itemBuilder: (context, index) {
                      final categoryItem = categoryItems[index];
                      return GestureDetector(
                        onTap: () => cartVM.addItemFromFood(categoryItem, 1),
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
                            color: context.colors.background,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: context.colors.defaultGrayEEEEEE,
                              width: 1.5.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.defaultGrayEEEEEE,
                                blurRadius: 1.r,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: Image.network(
                                  categoryItem.image,
                                  height: 100.h,
                                  width: 130.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                categoryItem.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyLargeMedium!.copyWith(
                                  color: context.colors.generalText,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset("assets/icons/star.svg"),
                                      SizedBox(width: 2.w),
                                      Text(
                                        "${categoryItem.rating}",
                                        style: textTheme.bodySmallMedium!
                                            .copyWith(
                                              color: context.colors.generalText,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/location_on.svg",
                                        colorFilter: ColorFilter.mode(
                                          context.colors.primary,
                                          BlendMode.srcIn,
                                        ),
                                        width: 10.w,
                                        height: 10.h,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        "120m",
                                        style: textTheme.bodySmallMedium!
                                            .copyWith(
                                              color: context.colors.generalText,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "\$${categoryItem.price}",
                                style: textTheme.bodyLargeBold!.copyWith(
                                  color: context.colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ),

          SizedBox(height: 15.h),

          Divider(height: 1.5.h, color: context.colors.defaultGray878787),

          SizedBox(height: 15.h),

          /// Payment Summary
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: context.colors.defaultGray878787,
                width: 1.w,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Summary",
                  style: textTheme.bodyLargeSemiBold!.copyWith(
                    color: context.colors.generalText,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Items (${cartState.items.length})",
                      style: textTheme.bodyMediumMedium!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                    Text(
                      "\$${cartState.totalPrice.toStringAsFixed(2)}",
                      style: textTheme.bodyMediumBold!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delivery Fee",
                      style: textTheme.bodyMediumMedium!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                    Text(
                      "Free",
                      style: textTheme.bodyMediumBold!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Item Handling Charge",
                      style: textTheme.bodyMediumMedium!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                    Text(
                      "\$${cartState.itemHandlingFee.toStringAsFixed(2)}",
                      style: textTheme.bodyMediumBold!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Tax",
                      style: textTheme.bodyMediumMedium!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                    Text(
                      "\$${cartState.totalTax.toStringAsFixed(2)}",
                      style: textTheme.bodyMediumBold!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Discount",
                      style: textTheme.bodyMediumMedium!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                    Text(
                      "-\$${cartState.orderDiscount.toStringAsFixed(2)}",
                      style: textTheme.bodyMediumBold!.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: textTheme.bodyMediumMedium!.copyWith(
                        color: context.colors.generalText,
                      ),
                    ),
                    Text(
                      "\$${cartState.total.toStringAsFixed(2)}",
                      style: textTheme.bodyMediumBold!.copyWith(
                        color: context.colors.generalText,
                      ),
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
                backgroundColor: context.colors.primary,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                "Order Now",
                style: textTheme.bodyMediumSemiBold!.copyWith(
                  color: context.colors.defaultWhite,
                ),
              ),
            ),
          ),

          SizedBox(height: 25.h),
        ],
      ),
    );
  }
}
