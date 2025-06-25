import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/model/food_item.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/screens/cart_screen.dart';
import 'package:smart_flutter/screens/chat_screen.dart';
import 'package:smart_flutter/screens/credit_card_screen.dart';
import 'package:smart_flutter/screens/email_otp_verification_screen.dart';
import 'package:smart_flutter/screens/forgot_password_screen.dart';
import 'package:smart_flutter/screens/home_screen.dart';
import 'package:smart_flutter/screens/login_screen.dart';
import 'package:smart_flutter/screens/onboarding_screen.dart';
import 'package:smart_flutter/screens/personal_data_screen.dart';
import 'package:smart_flutter/screens/product_details_screen.dart';
import 'package:smart_flutter/screens/profile_screen.dart';
import 'package:smart_flutter/screens/register_screen.dart';
import 'package:smart_flutter/screens/reset_password_screen.dart';
import 'package:smart_flutter/screens/settings_screen.dart';
import 'package:smart_flutter/views/widgets/bottom_tab_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final needsPassword = ref.read(needsPasswordSetupProvider);
      if (needsPassword) {
        ref.read(needsPasswordSetupProvider.notifier).state = false;
        return '/setPassword';
      }
      return null;
    },
    routes: [
      // Non-tab routes
      GoRoute(
        path: '/',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final bool showForgot = state.extra as bool? ?? false;
          return LoginScreen(shouldForgotPasswordModelOnLoad: showForgot);
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgotPassword',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/resetPassword',
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/emailOtpVerification',
        name: 'emailOtpVerification',
        builder: (context, state) => const EmailOtpVerificationScreen(),
      ),
      GoRoute(
        path: '/setPassword',
        name: 'setPassword',
        builder:
            (context, state) =>
                const LoginScreen(shouldForgotPasswordModelOnLoad: false),
      ),

      // ShellRoute for tab navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomTabShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        name: 'productDetails',
        builder: (context, state) {
          final foodItem = state.extra as FoodItem; // or fetch by ID
          return ProductDetailsScreen(foodItem: foodItem);
        },
      ),
      GoRoute(
        path: '/profileData',
        name: 'profileData',
        builder: (context, state) => const ProfileDataScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/credit_card',
        name: 'credit_card',
        builder: (context, state) => const CreditCardScreen(),
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('404: Page not found\n${state.error}')),
        ),
  );
});
