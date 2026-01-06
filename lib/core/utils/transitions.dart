import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A smooth fade + slight slide transition for GoRouter pages.
CustomTransitionPage<T> buildPageWithFadeSlide<T>(GoRouterState state, Widget child, {Duration duration = const Duration(milliseconds: 300)}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    child: child,
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      final fadeAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.05, 0), // slight slide from right
        end: Offset.zero,
      ).animate(fadeAnimation);

      return FadeTransition(opacity: fadeAnimation, child: SlideTransition(position: slideAnimation, child: child));
    },
  );
}
