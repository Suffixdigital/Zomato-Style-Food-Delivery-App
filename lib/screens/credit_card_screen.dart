import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/views/widgets/credit_card_screen/card_list_tile.dart';
import 'package:smart_flutter/views/widgets/credit_card_screen/credit_card_header.dart';
import 'package:smart_flutter/views/widgets/credit_card_screen/credit_card_widget.dart';

import '../viewmodels/credit_card_viewmodel.dart';

class CreditCardScreen extends ConsumerStatefulWidget {
  const CreditCardScreen({super.key});

  @override
  ConsumerState<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends ConsumerState<CreditCardScreen> {
  int selectedIndex = 0;

  Future<bool> onBackPressed() async {
    ref.read(persistentTabController).jumpToTab(3);
    Navigator.of(context).pop(); // no changes, just pop
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;

    final cards = ref.watch(creditCardListProvider);

    return WillPopScope(
      onWillPop: onBackPressed,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder:
            (context, child) => Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CreditCardHeader(
                      isTablet: isTablet,
                      onBackPressed: onBackPressed,
                    ),
                    SizedBox(height: 15.h),
                    CreditCardWidget(
                      isTablet: isTablet,
                      card: cards[selectedIndex],
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Credit card",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .bodyLargeMedium!
                            .copyWith(color: AppColors.neutral100),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cards.length,
                        itemBuilder:
                            (_, i) => GestureDetector(
                              onTap: () {
                                setState(() => selectedIndex = i);
                              },
                              child: CardListTile(
                                card: cards[i],
                                isSelected: selectedIndex == i,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: 10.h,
                    top: 10.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        "Add New Card",
                        style: AppTextTheme.fallback(isTablet: isTablet)
                            .bodyMediumSemiBold!
                            .copyWith(color: AppColors.neutral0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
