import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/routes/app_routes.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/viewmodels/personal_data_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links/uni_links.dart';

final deepLinkServiceProvider = Provider((ref) => DeepLinkService(ref));

class DeepLinkService {
  StreamSubscription? linkSub;
  StreamSubscription<AuthState>? authSub;

  final Ref ref;

  DeepLinkService(this.ref);

  void init() {
    // 1) Listen for incoming deep links
    getInitialUri().then(handleUri);
    linkSub = uriLinkStream.listen(handleUri);

    // 2) Listen to auth state changes for social login & successful email verification
    authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;

      debugPrint('[AuthState] Event=$event, Session=${session?.user.email}');

      switch (event) {
        case AuthChangeEvent.signedIn:
          final metadata = session?.user.userMetadata;
          final isSocialLogin = isOAuth(metadata);
          final hasPassword = metadata?['has_password'] ?? false;
          final emailConfirmed = session?.user.confirmedAt != null;

          await SharedPreferencesService.updateAuthFlags(userLoggedIn: isSocialLogin);

          if (isSocialLogin) {
            // Social login → go home
            ref.invalidate(personalDataProvider);
            safeNavigate('home');
          } else if (!emailConfirmed) {
            // Email link expired/invalid (not verified)
            processError('Email verification link is invalid or expired. Please request a new verification email.');
          } else if (!hasPassword) {
            // Newly verified user → set password
            SharedPreferencesService.updateAuthFlags(newPassword: true);
            safeNavigate('set-password');
          } else {
            // Normal login → go home
            safeNavigate('home');
          }
          break;

        case AuthChangeEvent.signedOut:
          await SharedPreferencesService.resetAuthFlags();
          break;

        default:
          break;
      }
    });
  }

  /// Handle incoming deep link manually (reset-password & optional register)
  Future<void> handleUri(Uri? uri) async {
    if (!isValidUri(uri)) return;

    debugPrint('[DeepLink] Handling URI: $uri');

    try {
      if (isResetUri(uri!)) {
        await processResetPassword(uri);
      } else if (isRegisterUri(uri)) {
        // Optional: manual register-user handling for expired/invalid links
        await processRegisterUser(uri);
      } else {
        debugPrint('[DeepLink] Social login handled automatically by Supabase');
      }
    } on AuthException catch (e) {
      debugPrint('[DeepLink] AuthException: ${e.message} (${e.code})');
      return processError('Link is invalid or expired. Please request a new one.');
    } catch (e) {
      debugPrint('[DeepLink] Unknown error: $e');
      return processError('An unexpected error occurred while processing the link.');
    }
  }

  /// Process reset-password link
  Future<void> processResetPassword(Uri uri) async {
    final code = uri.queryParameters['code'];
    if (code == null) {
      return processError('Reset password link is invalid or expired.');
    }

    try {
      final response = await Supabase.instance.client.auth.exchangeCodeForSession(code);
      if (response.session == null) {
        return processError('Reset password link is invalid or expired.');
      }

      SharedPreferencesService.updateAuthFlags(resetPassword: true);
      ref.read(linkExpiredMessage.notifier).state = '';
      safeNavigate('resetPassword');
    } on AuthException catch (e) {
      debugPrint('[DeepLink] AuthException: ${e.message} (${e.code})');
      return processError('Reset password link is invalid or expired.');
    } catch (e) {
      debugPrint('[DeepLink] Unknown error: $e');
      return processError('An unexpected error occurred while processing the link.');
    }
  }

  /// Optional: process register-user link for expired/invalid links
  Future<void> processRegisterUser(Uri uri) async {
    try {
      final response = await Supabase.instance.client.auth.getSessionFromUrl(uri);

      if (response.session == null) {
        return processError('Email verification link is invalid or expired.');
      }

      // Successful verification handled automatically via onAuthStateChange
      debugPrint('[DeepLink] register-user link successfully processed.');
    } on AuthException catch (e) {
      debugPrint('[DeepLink] AuthException: ${e.message} (${e.code})');
      return processError('Email verification link is invalid or expired.');
    } catch (e) {
      debugPrint('[DeepLink] Unknown error: $e');
      return processError('An unexpected error occurred while processing the link.');
    }
  }

  /// Show error messages and navigate safely
  Future<void> processError(String errorMessage) async {
    debugPrint('[DeepLink] Error: $errorMessage');
    ref.read(linkExpiredMessage.notifier).state = errorMessage;

    final ctx = navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final lastRoute = SharedPreferencesService.getLastRoute();
        debugPrint('[DeepLink] Redirecting from /callback → $lastRoute');

        if (lastRoute.isNotEmpty) {
          GoRouter.of(ctx).goNamed(lastRoute);
        } else {
          GoRouter.of(ctx).goNamed('login');
        }
      });
    }
  }

  /// Helpers
  bool isResetUri(Uri uri) => uri.path.contains('reset-password');

  bool isRegisterUri(Uri uri) => uri.path.contains('register-user');

  bool isOAuth(Map<String, dynamic>? metadata) {
    if (metadata == null) return false;
    final iss = metadata['iss']?.toString() ?? '';
    return iss.contains('google.com') || iss.contains('facebook.com') || iss.contains('twitter.com');
  }

  bool isValidUri(Uri? uri) {
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return path.contains('social-media-login') || path.contains('register-user') || path.contains('reset-password');
  }

  /// Navigate safely
  void safeNavigate(String routeName) {
    final ctx = navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      Future.microtask(() => ctx.goNamed(routeName));
    }
  }

  void dispose() {
    linkSub?.cancel();
    authSub?.cancel();
  }
}
