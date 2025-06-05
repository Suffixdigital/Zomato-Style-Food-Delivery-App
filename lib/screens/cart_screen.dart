import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/viewmodels/cart_viewmodel.dart';
import 'package:smart_flutter/views/widgets/cart_screen/cart_filled_view.dart';
import 'package:smart_flutter/views/widgets/cart_screen/cart_header.dart';
import 'package:smart_flutter/views/widgets/cart_screen/empty_cart_view.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;

    // Watch cart state
    final cartState = ref.watch(cartViewModelProvider);
    // Access notifier to call methods if needed:

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder:
          (context, child) => Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // Common Header (Back Button + Title)
                  CartHeader(),

                  // Content Below Header
                  Expanded(
                    child:
                        cartState.items.isEmpty
                            ? EmptyCartView(isTablet: isTablet)
                            : CartFilledView(isTablet: isTablet),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
