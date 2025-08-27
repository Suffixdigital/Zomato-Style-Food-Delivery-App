import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/model/CategoryItem.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/cart_viewmodel.dart';
import 'package:smart_flutter/viewmodels/home_viewmodel.dart';
import 'package:smart_flutter/views/widgets/shimmer_loader.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final CategoryItem categoryItem;

  const ProductDetailsScreen({super.key, required this.categoryItem});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;
  int currentIndex = 0;
  bool isFavorite = false;
  bool _showAppBar = true;
  double _lastOffset = 0;
  final ScrollController _scrollController = ScrollController();

  late List<String> imageList;

  @override
  void initState() {
    super.initState();
    imageList = [
      widget.categoryItem.image,
      widget.categoryItem.image,
      widget.categoryItem.image,
    ];

    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      if (offset > _lastOffset && _showAppBar) {
        setState(() => _showAppBar = false);
      } else if (offset < _lastOffset && !_showAppBar) {
        setState(() => _showAppBar = true);
      }
      _lastOffset = offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final relatedItemsAsync = ref.watch(
      relatedItemsProvider(widget.categoryItem.categoryId),
    );
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder:
          (context, child) => Scaffold(
            body: Stack(
              children: [
                /// Main scrollable content
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      /// Carousel with rounded bottom
                      Stack(
                        children: [
                          Hero(
                            tag: widget.categoryItem,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24.r),
                                bottomRight: Radius.circular(24.r),
                              ),
                              child: CarouselSlider.builder(
                                itemCount: imageList.length,
                                options: CarouselOptions(
                                  height: 320.h,
                                  autoPlay: true,
                                  viewportFraction: 1.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      currentIndex = index;
                                    });
                                  },
                                ),
                                itemBuilder: (context, index, _) {
                                  return Image.network(
                                    imageList[index],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),

                          /// Smooth indicator over image
                          Positioned(
                            bottom: 16.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: AnimatedSmoothIndicator(
                                activeIndex: currentIndex,
                                count: imageList.length,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 8.h,
                                  dotWidth: 20.h,
                                  activeDotColor: context.colors.defaultWhite,
                                  dotColor: context.colors.defaultGray878787,
                                  expansionFactor: 2,
                                ),
                                onDotClicked: (index) {
                                  setState(() => currentIndex = index);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// Product details and description
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.categoryItem.name,
                              style: textTheme.headingH5SemiBold!.copyWith(
                                color: context.colors.generalText,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "\$${widget.categoryItem.price}",
                              style: textTheme.headingH6Bold!.copyWith(
                                color: context.colors.primary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.primary.withValues(
                                  alpha: 0.06,
                                ),
                                // Light peach-like color
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/dollor.svg",
                                    width: 15.w,
                                    height: 15.h,
                                    colorFilter: ColorFilter.mode(
                                      context.colors.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Text(
                                    "Free Delivery",
                                    style: textTheme.bodyMediumRegular!
                                        .copyWith(
                                          color:
                                              context.colors.defaultGray878787,
                                        ),
                                  ),
                                  SizedBox(width: 50.w),
                                  SvgPicture.asset(
                                    "assets/icons/clock.svg",
                                    width: 15.w,
                                    height: 15.h,
                                    colorFilter: ColorFilter.mode(
                                      context.colors.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Text(
                                    " 20 - 30",
                                    style: textTheme.bodyMediumRegular!
                                        .copyWith(
                                          color:
                                              context.colors.defaultGray878787,
                                        ),
                                  ),
                                  SizedBox(width: 50.w),
                                  SvgPicture.asset(
                                    "assets/icons/star.svg",
                                    width: 15.w,
                                    height: 15.h,
                                    colorFilter: ColorFilter.mode(
                                      context.colors.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Text(
                                    " ${widget.categoryItem.rating}",
                                    style: textTheme.bodyMediumRegular!
                                        .copyWith(
                                          color:
                                              context.colors.defaultGray878787,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Divider(
                              color: context.colors.defaultGray878787,
                              height: 2.h,
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              "Description",
                              style: textTheme.bodyLargeSemiBold!.copyWith(
                                color: context.colors.generalText,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "${widget.categoryItem.description} ${widget.categoryItem.description} ${widget.categoryItem.description} ${widget.categoryItem.description}",
                              style: textTheme.bodyMediumRegular!.copyWith(
                                color: context.colors.defaultGray878787,
                              ),
                            ),
                            SizedBox(height: 24.h),
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
                                  style: textTheme.bodyLargeRegular!.copyWith(
                                    color: context.colors.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            relatedItemsAsync.when(
                              error:
                                  (err, stack) =>
                                      Center(child: Text('Error: $err')),
                              loading: () => Center(child: ShimmerLoader()),
                              data:
                                  (categoryItems) => SizedBox(
                                    height: 100.h,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categoryItems.length,
                                      separatorBuilder:
                                          (_, __) => SizedBox(width: 10.w),
                                      itemBuilder:
                                          (_, index) => ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            child: Image.network(
                                              categoryItems[index].image,
                                              width: 100.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Blurred AppBar with animation
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  top: 40.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.goNamed('home');
                        },
                        icon: DeviceUtils.backIcon(
                          "assets/icons/back.svg",
                          context.colors.generalText,
                          16,
                        ),
                      ),
                      Text(
                        "About This Menu",
                        style: textTheme.bodyLargeSemiBold!.copyWith(
                          color: context.colors.generalText,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder:
                            (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                        child: IconButton(
                          key: ValueKey(isFavorite),
                          onPressed:
                              () => setState(() => isFavorite = !isFavorite),
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.colors.defaultGray878787,
                                // border color
                                width: 1.w, // border width
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 16.r,
                              backgroundColor:
                                  isFavorite
                                      ? context.colors.defaultWhite
                                      : Colors.transparent,
                              child:
                                  isFavorite
                                      ? SvgPicture.asset(
                                        "assets/icons/favorite_selected.svg",
                                        width: 16.w,
                                        height: 16.h,
                                        colorFilter: ColorFilter.mode(
                                          context.colors.error,
                                          BlendMode.srcIn,
                                        ),
                                      )
                                      : SvgPicture.asset(
                                        "assets/icons/favorite.svg",
                                        width: 16.w,
                                        height: 16.h,
                                        colorFilter: ColorFilter.mode(
                                          context.colors.defaultWhite,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.h,
                bottom: 56.h,
                top: 10.h,
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (quantity > 1) {
                            setState(() => quantity--);
                          }
                        },
                        child: DeviceUtils.backIcon(
                          "assets/icons/minus.svg",
                          quantity > 1
                              ? context.colors.generalText
                              : context.colors.defaultGray878787,
                          16,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "$quantity",
                        style: AppTextTheme.fallback(isTablet: false)
                            .headingH6SemiBold!
                            .copyWith(color: context.colors.generalText),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: () => setState(() => quantity++),
                        child: DeviceUtils.backIcon(
                          "assets/icons/plus.svg",
                          context.colors.generalText,
                          16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final cartVM = ref.read(cartViewModelProvider.notifier);
                        cartVM.addItemFromFood(widget.categoryItem, quantity);
                        context.goNamed('home');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.categoryItem.name} added to cart!',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      icon: SvgPicture.asset(
                        "assets/icons/cart_icon.svg",
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          context.colors.defaultWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: Text(
                        "Add to Cart",
                        style: textTheme.bodyMediumSemiBold!.copyWith(
                          color: context.colors.defaultWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
