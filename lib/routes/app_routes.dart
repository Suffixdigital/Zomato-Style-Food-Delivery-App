// app_routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/core/utils/transitions.dart';
import 'package:smart_flutter/model/CategoryItem.dart';
import 'package:smart_flutter/model/email_phone_link_request.dart';
import 'package:smart_flutter/routes/route_tracking_observer.dart';
import 'package:smart_flutter/screens/EmailOtpVerificationScreen.dart';
import 'package:smart_flutter/screens/address_lilst_screen.dart';
import 'package:smart_flutter/screens/cart_screen.dart';
import 'package:smart_flutter/screens/chat_screen.dart';
import 'package:smart_flutter/screens/credit_card_screen.dart';
import 'package:smart_flutter/screens/forgot_password_screen.dart';
import 'package:smart_flutter/screens/home_screen.dart';
import 'package:smart_flutter/screens/login_screen.dart';
import 'package:smart_flutter/screens/onboarding_screen.dart';
import 'package:smart_flutter/screens/permission_onboarding_screen.dart';
import 'package:smart_flutter/screens/personal_data_screen.dart';
import 'package:smart_flutter/screens/product_details_screen.dart';
import 'package:smart_flutter/screens/profile_screen.dart';
import 'package:smart_flutter/screens/register_screen.dart';
import 'package:smart_flutter/screens/reset_password_screen.dart';
import 'package:smart_flutter/screens/set_password_screen.dart';
import 'package:smart_flutter/screens/settings_screen.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/views/widgets/bottom_tab_shell.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/onboarding',
    observers: [RouteTrackingObserver()],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final onboardingDone = SharedPreferencesService.isOnboardingCompleted();
      final permissionsGranted = SharedPreferencesService.isPermissionDone();
      final isUserLoggedIn = SharedPreferencesService.isUserLoggedIn();
      final isPhoneOTPAuthenticated = SharedPreferencesService.isPhoneOTPAuthenticated();
      final isResetPassword = SharedPreferencesService.isResetPassword();
      final isNewPassword = SharedPreferencesService.isNewPassword();

      final location = state.matchedLocation;

      // Special-case routes (deep link callbacks, onboarding, etc.)
      final isOnboardingScreen = location == '/onboarding';
      final isPermissionScreen = location == '/permissions';
      final isCallbackScreen = (location == '/social-media-login' || location == '/register-user' || location == '/reset-password');

      print(
        "redirect check → "
        "onboardingDone:$onboardingDone isOnboardingScreen:$isOnboardingScreen permissionsGranted:$permissionsGranted "
        "isUserLoggedIn:$isUserLoggedIn isPhoneOTPAuthenticated:$isPhoneOTPAuthenticated "
        "isResetPassword:$isResetPassword isNewPassword:$isNewPassword "
        "location:$location isCallbackScreen:$isCallbackScreen",
      );

      // let deep link callbacks resolve themselves
      if (isCallbackScreen) return null;

      if (onboardingDone) {
        if (!permissionsGranted) {
          return '/permissions';
        }

        // handle reset-password flow
        if (isResetPassword) {
          return '/resetPassword';
        }

        // handle new-password flow
        if (isNewPassword) {
          return '/set-password';
        }

        // handle logged-in vs logged-out
        if (isUserLoggedIn || isPhoneOTPAuthenticated) {
          if (!isOnboardingScreen) {
            return null;
          }
          return '/home'; // already logged in → go home
        } else {
          if (!isOnboardingScreen) {
            return null;
          }
          // logged out
          return '/login';
        }
      } else {
        // handle onboarding
        return '/onboarding';
      }
    },
    routes: [
      GoRoute(path: '/onboarding', name: 'onboarding', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const OnboardingScreen())),
      GoRoute(path: '/permissions', name: 'permissions', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const PermissionOnboardingScreen())),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        pageBuilder: (_, __) => buildPageWithFadeSlide(__, const Scaffold(body: Center(child: Text("Processing deep link...")))),
      ),
      GoRoute(
        path: '/register-user',
        name: 'register-user',
        pageBuilder: (_, __) => buildPageWithFadeSlide(__, const Scaffold(body: Center(child: Text("Processing deep link...")))),
      ),
      GoRoute(path: '/login', name: 'login', pageBuilder: (_, __) => buildPageWithFadeSlide(__, LoginScreen())),
      GoRoute(
        path: '/phoneOtpVerification/:phone',
        name: 'phoneOtpVerification',
        builder: (_, state) {
          final phoneNumber = state.pathParameters["phone"]!;
          return PhoneOtpVerificationScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(path: '/register', name: 'register', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const RegisterScreen())),
      GoRoute(path: '/forgotPassword', name: 'forgotPassword', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const ForgotPasswordScreen())),
      GoRoute(path: '/resetPassword', name: 'resetPassword', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const ResetPasswordScreen())),
      GoRoute(
        path: '/set-password',
        name: 'set-password',
        pageBuilder: (context, state) {
          final data = state.extra as EmailPhoneLinkRequest?;
          return buildPageWithFadeSlide(state, SetPasswordScreen(request: data));
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        observers: [RouteTrackingObserver()],
        builder: (_, __, child) => BottomTabShell(child: child),
        routes: [
          GoRoute(path: '/home', name: 'home', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const HomeScreen())),
          GoRoute(path: '/cart', name: 'cart', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const CartScreen())),
          GoRoute(path: '/chat', name: 'chat', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const ChatScreen())),
          GoRoute(path: '/profile', name: 'profile', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const ProfileScreen())),
        ],
      ),

      /*GoRoute(
        path: '/product/:id',
        name: 'productDetails',
        builder: (_, state) {
          final categoryItem = state.extra as CategoryItem;
          return ProductDetailsScreen(categoryItem: categoryItem);
        },
      ),*/
      GoRoute(
        path: '/product/:id',
        name: 'productDetails',
        pageBuilder: (context, state) {
          final categoryItem = state.extra as CategoryItem;
          return buildPageWithFadeSlide(state, ProductDetailsScreen(categoryItem: categoryItem));
        },
      ),
      GoRoute(path: '/profileData', name: 'profileData', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const ProfileDataScreen())),
      GoRoute(path: '/settings', name: 'settings', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const SettingsScreen())),
      GoRoute(path: '/credit_card', name: 'credit_card', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const CreditCardScreen())),
      GoRoute(path: '/addressList', name: 'addressList', pageBuilder: (_, __) => buildPageWithFadeSlide(__, const AddressListScreen())),
    ],
    errorBuilder: (_, state) => Scaffold(body: Center(child: Text('404: Page not found\n${state.uri}'))),
  );
});
