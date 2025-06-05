import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/model/food_item.dart';
import 'package:smart_flutter/screens/persistent_bottom_navigation.dart';
import 'package:smart_flutter/viewmodels/cart_viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final FoodItem foodItem;

  const ProductDetailsScreen({super.key, required this.foodItem});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _quantity = 1;
  int _current = 0;
  bool _isFavorite = false;
  bool _showAppBar = true;
  double _lastOffset = 0;
  final ScrollController _scrollController = ScrollController();

  final List<String> imageList = [
    'assets/images/burger1.png',
    'assets/images/burger2.png',
    'assets/images/burger3.png',
  ];

  final List<String> _images = [
    'assets/images/burger1.png',
    'assets/images/burger2.png',
    'assets/images/burger3.png',
    'assets/images/burger1.png',
    'assets/images/burger2.png',
    'assets/images/burger3.png',
    'assets/images/burger1.png',
    'assets/images/burger2.png',
    'assets/images/burger3.png',
  ];

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
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
                      tag: widget.foodItem,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24.r),
                          bottomRight: Radius.circular(24.r),
                        ),
                        child: CarouselSlider.builder(
                          itemCount: imageList.length,
                          options: CarouselOptions(
                            height: 300.h,
                            autoPlay: true,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          itemBuilder: (context, index, _) {
                            return Image.asset(
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
                          activeIndex: _current,
                          count: imageList.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8.h,
                            dotWidth: 8.h,
                            activeDotColor: Colors.white,
                            dotColor: Colors.white30,
                            expansionFactor: 3,
                          ),
                          onDotClicked: (index) {
                            setState(() => _current = index);
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                /// Dummy product content (you can replace with yours)
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.foodItem.title,
                        style: AppTextTheme.fallback(isTablet: false)
                            .headingH5SemiBold!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "\$${widget.foodItem.price}",
                        style: AppTextTheme.fallback(isTablet: false)
                            .headingH6Bold!
                            .copyWith(color: AppColors.primaryAccent),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent.withValues(
                            alpha: 0.06,
                          ),
                          // Light peach-like color
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/dollor.svg",
                              width: 15.w,
                              height: 15.h,
                              colorFilter: ColorFilter.mode(
                                AppColors.primaryAccent,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              "Free Delivery",
                              style: AppTextTheme.fallback(isTablet: false)
                                  .bodyMediumRegular!
                                  .copyWith(color: AppColors.neutral60),
                            ),
                            SizedBox(width: 50.w),
                            SvgPicture.asset(
                              "assets/icons/clock.svg",
                              width: 15.w,
                              height: 15.h,
                              colorFilter: ColorFilter.mode(
                                AppColors.primaryAccent,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              " 20 - 30",
                              style: AppTextTheme.fallback(isTablet: false)
                                  .bodyMediumRegular!
                                  .copyWith(color: AppColors.neutral60),
                            ),
                            SizedBox(width: 50.w),
                            SvgPicture.asset(
                              "assets/icons/star.svg",
                              width: 15.w,
                              height: 15.h,
                              colorFilter: ColorFilter.mode(
                                AppColors.primaryAccent,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              " 4.5",
                              style: AppTextTheme.fallback(isTablet: false)
                                  .bodyMediumRegular!
                                  .copyWith(color: AppColors.neutral60),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Divider(color: AppColors.neutral30, height: 2.h),
                      SizedBox(height: 15.h),
                      Text(
                        "Description",
                        style: AppTextTheme.fallback(isTablet: false)
                            .bodyLargeSemiBold!
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Burger With Meat is a typical food from our restaurant that is much in demand by many people, this is very recommended for you.",
                        style: AppTextTheme.fallback(isTablet: false)
                            .bodyMediumRegular!
                            .copyWith(color: AppColors.neutral60),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recommended For You",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 100.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          separatorBuilder: (_, __) => SizedBox(width: 10.w),
                          itemBuilder:
                              (_, index) => ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.asset(
                                  _images[index],
                                  width: 100.w,
                                  fit: BoxFit.cover,
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
            top: _showAppBar ? 40.h : 40.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersistentBottomNavigation(),
                      ),
                    ); // Or any tab index you want to return to Home screen
                  },
                  icon: DeviceUtils.backIcon(
                    "assets/icons/back.svg",
                    AppColors.neutral0,
                    16,
                  ),
                ),
                Text(
                  "About This Menu",
                  style: AppTextTheme.fallback(
                    isTablet: false,
                  ).bodyLargeSemiBold!.copyWith(color: AppColors.neutral0),
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: IconButton(
                    key: ValueKey(_isFavorite),
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.neutral0, // border color
                          width: 1.w, // border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundColor:
                            _isFavorite
                                ? Colors.transparent
                                : AppColors.neutral0,
                        child:
                            _isFavorite
                                ? SvgPicture.asset(
                                  "assets/icons/favorite.svg",
                                  width: 16.w,
                                  height: 16.h,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.neutral0,
                                    BlendMode.srcIn,
                                  ),
                                )
                                : SvgPicture.asset(
                                  "assets/icons/favorite_selected.svg",
                                  width: 16.w,
                                  height: 16.h,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.errorBase,
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
          bottom: 48.h,
          top: 10.h,
        ),
        child: Row(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_quantity > 1) {
                      setState(() => _quantity--);
                    }
                  },
                  child: DeviceUtils.backIcon(
                    "assets/icons/minus.svg",
                    _quantity > 1 ? AppColors.neutral100 : AppColors.neutral60,
                    16,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  "$_quantity",
                  style: AppTextTheme.fallback(
                    isTablet: false,
                  ).headingH6SemiBold!.copyWith(color: AppColors.neutral100),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () => setState(() => _quantity++),
                  child: DeviceUtils.backIcon(
                    "assets/icons/plus.svg",
                    AppColors.neutral100,
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
                  cartVM.addItemFromFood(widget.foodItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.foodItem.title} added to cart!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
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
                    AppColors.neutral0,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  "Add to Cart",
                  style: AppTextTheme.fallback(
                    isTablet: false,
                  ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
