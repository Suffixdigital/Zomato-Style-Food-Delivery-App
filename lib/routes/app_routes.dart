import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/model/CategoryItem.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/onboarding',
    observers: [RouteTrackingObserver()],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;
      final currentUser = supabase.auth.currentUser;

      final onboardingDone = SharedPreferencesService.isOnboardingCompleted();
      final permissionsGranted = SharedPreferencesService.isPermissionDone();
      final isUserLoggedIn = SharedPreferencesService.isUserLoggedIn();
      final isPhoneOTPAuthenticated = SharedPreferencesService.isPhoneOTPAuthenticated();
      final isResetPassword = SharedPreferencesService.isResetPassword();
      final isNewPassword = SharedPreferencesService.isNewPassword();
      final location = state.matchedLocation;

      // Flags for routes
      final isOnboardingScreen = location == '/onboarding';
      final isPermissionScreen = location == '/permissions';
      final isSetPasswordScreen = location == '/set-password';
      final isCallbackScreen = (location == '/social-media-login' || location == '/register-user' || location == '/reset-password');

      print(
        "session: ${session == null},  permissionsGranted: $permissionsGranted  isPermissionScreen: $isPermissionScreen isResetPassword:$isResetPassword isCallbackScreen: $isCallbackScreen isOnboardingScreen: $isOnboardingScreen isSetPasswordScreen: $isSetPasswordScreen  onboardingDone: $onboardingDone,  location: $location isUserLoggedIn:$isUserLoggedIn",
      );

      if (isCallbackScreen) return null;

      if (onboardingDone) {
        if (session != null) {
          final metadata = session.user.userMetadata;
          final isPhoneLogin = session.user.phone != null;
          final isSocialLogin =
              metadata != null &&
              metadata.containsKey('provider_id') &&
              (metadata['iss']?.toString().contains('google.com') == true ||
                  metadata['iss']?.toString().contains('facebook.com') == true ||
                  metadata['iss']?.toString().contains('twitter.com') == true);
          print('session data tokenType: ${session.tokenType}  session:${session.user}  user: $metadata');
          print('Check user-login isUserLoggedIn:$isUserLoggedIn isSocialLogin: $isSocialLogin  check new password set:$isNewPassword');
          if (isUserLoggedIn && !isOnboardingScreen) {
            return null;
          }

          if (isResetPassword) {
            return '/resetPassword';
          }

          // Phone users should skip password setup
          if (isPhoneOTPAuthenticated) {
            SharedPreferencesService.setUserLoggedIn(true);
            SharedPreferencesService.setPhoneOTPAuthenticated(true);
            return '/home';
          }

          if (isNewPassword && !isSocialLogin) {
            return '/set-password';
          }

          if (isSocialLogin || isUserLoggedIn) {
            SharedPreferencesService.setUserLoggedIn(true);
            SharedPreferencesService.setPhoneOTPAuthenticated(false);
            return '/home';
          }

          return '/login';
        } else {
          if (isOnboardingScreen) {
            return '/login';
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', name: 'onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/permissions', name: 'permissions', builder: (_, __) => const PermissionOnboardingScreen()), // new
      GoRoute(path: '/reset-password', name: 'reset-password', builder: (_, __) => const Scaffold(body: Center(child: Text("Processing deep link...")))),
      GoRoute(path: '/register-user', name: 'register-user', builder: (_, __) => const Scaffold(body: Center(child: Text("Processing deep link...")))),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: '/phoneOtpVerification/:phone',
        name: 'phoneOtpVerification',
        builder: (_, state) {
          final phoneNumber = state.pathParameters["phone"]!;
          return PhoneOtpVerificationScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(path: '/register', name: 'register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/forgotPassword',
        name: 'forgotPassword',
        builder: (_, __) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(path: '/resetPassword', name: 'resetPassword', builder: (_, __) => const ResetPasswordScreen()),
      GoRoute(path: '/set-password', name: 'set-password', builder: (_, __) => const SetPasswordScreen()),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        observers: [RouteTrackingObserver()], // attach to shell
        // parentNavigatorKey: navigatorKey,
        builder: (_, __, child) => BottomTabShell(child: child),
        routes: [
          GoRoute(path: '/home', name: 'home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/cart', name: 'cart', builder: (_, __) => const CartScreen()),
          GoRoute(path: '/chat', name: 'chat', builder: (_, __) => const ChatScreen()),
          GoRoute(path: '/profile', name: 'profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),

      GoRoute(
        path: '/product/:id',
        name: 'productDetails',
        builder: (_, state) {
          final categoryItem = state.extra as CategoryItem;
          return ProductDetailsScreen(categoryItem: categoryItem);
        },
      ),
      GoRoute(path: '/profileData', name: 'profileData', builder: (_, __) => const ProfileDataScreen()),
      GoRoute(path: '/settings', name: 'settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/credit_card', name: 'credit_card', builder: (_, __) => const CreditCardScreen()),
      GoRoute(path: '/addressList', name: 'addressList', builder: (_, __) => const AddressListScreen()),
    ],
    errorBuilder: (_, state) => Scaffold(body: Center(child: Text('404: Page not found\n${state.uri}'))),
  );
});
