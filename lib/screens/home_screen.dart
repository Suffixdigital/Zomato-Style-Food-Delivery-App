import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/model/CategoryItem.dart';
import 'package:smart_flutter/model/category.dart';
import 'package:smart_flutter/model/food_item.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/screens/link_expired_dialog.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/home_viewmodel.dart';
import 'package:smart_flutter/views/widgets/ShimmerGridLoader.dart';
import 'package:smart_flutter/views/widgets/shimmer_loader.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int? selectedIndex = 0;
  List<FoodItem> currentItems = [];
  bool hasLoadedFirstCategoryItems = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.read(linkExpiredMessage);
    final homeStateAsync = ref.watch(homeViewModelProvider);
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LinkExpiredDialog.show(context, message);
        ref.watch(linkExpiredMessage.notifier).state = '';
      });
    }

    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder:
          (context, child) => LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              int crossAxisCount =
                  screenWidth > 900
                      ? 4
                      : screenWidth > 600
                      ? 3
                      : 2;

              return Scaffold(
                body: homeStateAsync.when(
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  loading: () => Center(child: ShimmerLoader()),
                  data: (homeState) {
                    final categories = homeState.categories;
                    final items = homeState.items;
                    final selectedIndex = homeState.selectedIndex;

                    if (categories.isEmpty) {
                      return const Center(child: Text('No categories found.'));
                    }

                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 220.h,
                          pinned: true,
                          backgroundColor: context.colors.primary,
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding: EdgeInsets.only(left: 16.w, top: 40.h, bottom: 16.h, right: 40.w),
                            title: Text('Provide the best food for you', style: textTheme.headingH5SemiBold!.copyWith(color: context.colors.defaultWhite)),
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset('assets/images/header_background.png', fit: BoxFit.fill),
                                Container(
                                  color: context.colors.defaultBlack.withValues(alpha: 0.1), // Optional overlay for readability
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pushNamed('addressList');
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Your Location", style: textTheme.bodyMediumRegular!.copyWith(color: context.colors.defaultGrayEEEEEE)),
                                                SizedBox(height: 5.h),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/location_on.svg",
                                                      width: 20.w,
                                                      height: 24.h,
                                                      colorFilter: ColorFilter.mode(context.colors.defaultGrayEEEEEE, BlendMode.srcIn),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      "New York City",
                                                      style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.defaultGrayEEEEEE),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    Icon(Icons.keyboard_arrow_down_rounded, color: context.colors.defaultGrayEEEEEE, size: 18.sp),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          Row(
                                            children: [
                                              DeviceUtils.homeScreenIcon("assets/icons/search.svg", context.colors.defaultGrayEEEEEE),
                                              SizedBox(width: 10.w),
                                              DeviceUtils.homeScreenIcon("assets/icons/notification_bell.svg", context.colors.defaultGrayEEEEEE),
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
                                Text("Find by Category", style: textTheme.bodyLargeSemiBold!.copyWith(color: context.colors.generalText)),
                                Text("See All", style: textTheme.bodyMediumMedium!.copyWith(color: context.colors.primary)),
                              ],
                            ),
                          ),
                        ),

                        // Category Scroll
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                            child: SizedBox(
                              height: 100.h,
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                itemCount: categories.length,
                                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      ref.read(homeViewModelProvider.notifier).selectCategory(index);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                                      child: SizedBox(width: 74.w, child: _buildCategoryIcon(category, selectedIndex == index)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        /// Items Grid
                        if (homeState.isLoadingItems)
                          ShimmerGridLoader()
                        else if (items.isEmpty)
                          SliverToBoxAdapter(child: Center(child: Text("No items available")))
                        else
                          SliverPadding(
                            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h, bottom: 24.h),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate((context, index) => _buildBurgerCard(items[index]), childCount: items.length),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                              ),
                            ),
                          ),

                        // Burger Grid Items
                      ],
                    );
                  },
                ),
              );
            },
          ),
    );
  }

  Widget _buildCategoryIcon(Category category, bool selected) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: selected ? context.colors.primary : context.colors.background,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: selected ? context.colors.primary : context.colors.defaultGrayEEEEEE, width: 1.w),
        boxShadow: [BoxShadow(color: selected ? context.colors.primary : context.colors.defaultGrayEEEEEE, blurRadius: 1.r, offset: Offset(0, 1))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(category.icon, width: 28.w, height: 28.w, errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 28.w)),
          SizedBox(height: 6.h),
          SizedBox(
            height: 36.h,
            child: Text(
              category.label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMediumMedium!.copyWith(color: selected ? context.colors.defaultWhite : context.colors.defaultGray878787),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBurgerCard(CategoryItem categoryItem) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'productDetails',
          pathParameters: {
            'id': categoryItem.id.toString(), // just for route uniqueness
          },
          extra: categoryItem,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: context.colors.background,
          border: Border.all(color: context.colors.defaultGrayEEEEEE, width: 1.w),
          boxShadow: [BoxShadow(color: context.colors.defaultGrayEEEEEE, blurRadius: 1.r, blurStyle: BlurStyle.outer, offset: Offset(0, 1))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 4.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(categoryItem.image, height: 145.h, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 15.h,
                  right: 15.w,
                  child: CircleAvatar(
                    radius: 14.r,
                    backgroundColor: context.colors.defaultWhite,
                    child: SvgPicture.asset(
                      "assets/icons/favorite.svg",
                      width: 16.w,
                      height: 16.h,
                      colorFilter: ColorFilter.mode(context.colors.error, BlendMode.srcIn),
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
                  Text(categoryItem.name, style: textTheme.bodyLargeBold!.copyWith(color: context.colors.generalText)),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: context.colors.primary, size: 14.sp),
                      Text('4.9', style: textTheme.bodySmallRegular!.copyWith(color: context.colors.generalText)),
                      SizedBox(width: 8.w),
                      Icon(Icons.location_on, size: 14.sp, color: context.colors.primary),
                      Text('190m', style: textTheme.bodySmallRegular!.copyWith(color: context.colors.generalText)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text('\$ 17,230', style: textTheme.bodyMediumBold!.copyWith(color: context.colors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
