import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/model/food_item.dart';
import 'package:smart_flutter/routes/route_tracking_observer.dart';
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
import 'package:smart_flutter/screens/set_password_screen.dart';
import 'package:smart_flutter/screens/settings_screen.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/views/widgets/bottom_tab_shell.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  //final initialRoute = ref.watch(initialRouteProvider);
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/onboarding',
    observers: [RouteTrackingObserver()],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;

      final onboardingDone = SharedPreferencesService.isOnboardingCompleted();
      final isUserLoggedIn = SharedPreferencesService.isUserLoggedIn();
      final isResetPassword = SharedPreferencesService.isResetPassword();
      final location = state.matchedLocation;

      // Flags for routes
      final isOnboardingScreen = location == '/onboarding';
      final isSetPasswordScreen = location == '/set-password';
      final isCallbackScreen =
          (location == '/callback' || location == '/reset-password');

      print(
        "session: ${session == null}, isResetPassword:$isResetPassword isCallbackScreen: $isCallbackScreen isOnboardingScreen: $isOnboardingScreen isSetPasswordScreen: $isSetPasswordScreen  onboardingDone: $onboardingDone,  location: $location isUserLoggedIn:$isUserLoggedIn",
      );

      if (isCallbackScreen || isResetPassword) return null;

      if (onboardingDone) {
        if (session != null) {
          final metadata = session.user.userMetadata;
          final isSocialLogin =
              metadata != null &&
              metadata.containsKey('provider_id') &&
              (metadata['iss']?.toString().contains('google.com') == true ||
                  metadata['iss']?.toString().contains('facebook.com') ==
                      true ||
                  metadata['iss']?.toString().contains('twitter.com') == true);
          final isPasswordSet = metadata!['password_set'] == true;
          print(
            'session data tokenType: ${session.tokenType}    user: $metadata',
          );
          print(
            'Check user-login isUserLoggedIn:$isUserLoggedIn isSocialLogin: $isSocialLogin  check password set:$isPasswordSet',
          );
          if (isUserLoggedIn && !isOnboardingScreen) {
            return null;
          }

          if (!isPasswordSet && !isSocialLogin) {
            return '/set-password';
          }

          if (isSocialLogin || isUserLoggedIn) {
            return '/home';
          }
        } else {
          if (isOnboardingScreen) {
            return '/login';
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder:
            (_, __) => const Scaffold(
              body: Center(child: Text("Processing deep link...")),
            ),
      ),
      GoRoute(
        path: '/callback',
        name: 'callback',
        builder:
            (_, __) => const Scaffold(
              body: Center(child: Text("Processing deep link...")),
            ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgotPassword',
        name: 'forgotPassword',
        builder: (_, __) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: '/resetPassword',
        name: 'resetPassword',
        builder: (_, __) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/emailOtpVerification',
        name: 'emailOtpVerification',
        builder: (_, __) => const EmailOtpVerificationScreen(),
      ),
      GoRoute(
        path: '/set-password',
        name: 'set-password',
        builder: (_, __) => const SetPasswordScreen(),
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        observers: [RouteTrackingObserver()], // attach to shell
        // parentNavigatorKey: navigatorKey,
        builder: (_, __, child) => BottomTabShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (_, __) => const CartScreen(),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder: (_, __) => const ChatScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/product/:id',
        name: 'productDetails',
        builder: (_, state) {
          final foodItem = state.extra as FoodItem;
          return ProductDetailsScreen(foodItem: foodItem);
        },
      ),
      GoRoute(
        path: '/profileData',
        name: 'profileData',
        builder: (_, __) => const ProfileDataScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/credit_card',
        name: 'credit_card',
        builder: (_, __) => const CreditCardScreen(),
      ),
    ],
    errorBuilder:
        (_, state) => Scaffold(
          body: Center(child: Text('404: Page not found\n${state.uri}')),
        ),
  );
});
