import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/data/dummy_data.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/model/food_item.dart';

import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedIndex = 0;

  final List<Map<String, String>> categories = [
    {"icon": "assets/images/burger.png", "label": "Burger"},
    {"icon": "assets/images/taco.png", "label": "Taco"},
    {"icon": "assets/images/drink.png", "label": "Drink"},
    {"icon": "assets/images/pizza.png", "label": "Pizza"},
    {"icon": "assets/images/burger.png", "label": "Burger"},
    {"icon": "assets/images/taco.png", "label": "Taco"},
    {"icon": "assets/images/drink.png", "label": "Drink"},
    {"icon": "assets/images/pizza.png", "label": "Pizza"},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        int crossAxisCount =
            screenWidth > 900
                ? 4
                : screenWidth > 600
                ? 3
                : 2;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220.h,
                pinned: true,
                backgroundColor: AppColors.primaryAccent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: 16.w,
                    top: 40.h,
                    bottom: 16.h,
                    right: 40.w,
                  ),
                  title: Text(
                    'Provide the best food for you',
                    style: AppTextTheme.fallback(
                      isTablet: false,
                    ).headingH5SemiBold!.copyWith(color: AppColors.neutral0),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/header_background.png',
                        fit: BoxFit.fill,
                      ),
                      Container(
                        color: AppColors.neutral100.withValues(
                          alpha: 0.3,
                        ), // Optional overlay for readability
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 50.h,
                        ),
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
                                      "Your Location",
                                      style: AppTextTheme.fallback(
                                        isTablet: false,
                                      ).bodyMediumRegular!.copyWith(
                                        color: AppColors.neutral0,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/location_on.svg",
                                          width: 20.w,
                                          height: 24.h,
                                          colorFilter: ColorFilter.mode(
                                            AppColors.neutral0,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "New York City",
                                          style: AppTextTheme.fallback(
                                            isTablet: false,
                                          ).bodyMediumSemiBold!.copyWith(
                                            color: AppColors.neutral0,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.neutral0,
                                          size: 18.sp,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    DeviceUtils.homeScreenIcon(
                                      "assets/icons/search.svg",
                                    ),
                                    SizedBox(width: 10.w),
                                    DeviceUtils.homeScreenIcon(
                                      "assets/icons/notification_bell.svg",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.h, top: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Find by Category",
                        style: AppTextTheme.fallback(isTablet: false)
                            .bodyLargeSemiBold!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      Text(
                        "See All",
                        style: AppTextTheme.fallback(isTablet: false)
                            .bodyMediumMedium!
                            .copyWith(color: AppColors.primaryAccent),
                      ),
                    ],
                  ),
                ),
              ),
              // Category Scroll
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 14.w,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex =
                                  selectedIndex == index ? null : index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                            child: SizedBox(
                              width: 65.w,
                              child: _buildCategoryIcon(
                                item["icon"]!,
                                item["label"]!,
                                selectedIndex == index,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Burger Grid Items
              SliverPadding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 4.h,
                  bottom: 120.h,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildBurgerCard(foodItems[index]),
                    childCount: foodItems.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcon(String icon, String label, bool selected) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryAccent : AppColors.neutral0,
        borderRadius: BorderRadius.circular(10.r),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 28.w, height: 28.w),
          SizedBox(height: 6.h),
          Text(
            label,
            style: AppTextTheme.fallback(
              isTablet: false,
            ).bodyMediumMedium!.copyWith(
              color: selected ? AppColors.neutral0 : AppColors.neutral60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBurgerCard(FoodItem foodItem) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(foodItem: foodItem),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.neutral0,
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral20,
              spreadRadius: 1.r,
              blurRadius: 2.r,
              blurStyle: BlurStyle.solid,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      foodItem.imageUrl,
                      height: 145.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 15.h,
                  right: 15.w,
                  child: CircleAvatar(
                    radius: 14.r,
                    backgroundColor: AppColors.neutral0,
                    child: SvgPicture.asset(
                      "assets/icons/favorite.svg",
                      width: 16.w,
                      height: 16.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.errorBase,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w, right: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.primaryAccent,
                        size: 14.sp,
                      ),
                      Text('4.9', style: TextStyle(fontSize: 12.sp)),
                      SizedBox(width: 10.w),
                      Icon(
                        Icons.location_on,
                        size: 14.sp,
                        color: AppColors.primaryAccent,
                      ),
                      Text('190m', style: TextStyle(fontSize: 12.sp)),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '\$ 17,230',
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int? selectedIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {"icon": 'assets/images/burger.png', "label": "Burger"},
    {"icon": 'assets/images/taco.png', "label": "Taco"},
    {"icon": 'assets/images/drink.png', "label": "Drink"},
    {"icon": 'assets/images/pizza.png', "label": "Pizza"},
    {"icon": 'assets/images/burger.png', "label": "Burger"},
    {"icon": 'assets/images/taco.png', "label": "Taco"},
    {"icon": 'assets/images/drink.png', "label": "Drink"},
    {"icon": 'assets/images/pizza.png', "label": "Pizza"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.095, // Adjust height as needed
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 2.w),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final item = categories[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = selectedIndex == index ? null : index;
              });
            },
            child: SizedBox(
              width: 65.w,
              child: _buildCategoryIcon(
                item["icon"],
                item["label"],
                selectedIndex == index,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryIcon(String iconPath, String label, bool selected) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color:
            selected
                ? AppColors.primaryAccent.withOpacity(0.8)
                : AppColors.neutral0,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 24.sp,
            height: 24.sp,
            fit: BoxFit.contain,
          ),

          SizedBox(height: 5.h),
          Text(
            label,
            style: AppTextTheme.fallback(
              isTablet: false,
            ).bodyMediumMedium!.copyWith(
              color: selected ? AppColors.neutral0 : AppColors.neutral60,
            ),
          ),
        ],
      ),
    );
  }
}
