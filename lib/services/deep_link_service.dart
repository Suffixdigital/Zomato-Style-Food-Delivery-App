import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/core/utils/unifiedAuthResult.dart';
import 'package:smart_flutter/routes/app_routes.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/viewmodels/personal_data_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links/uni_links.dart';

final deepLinkServiceProvider = Provider((ref) => DeepLinkService(ref));

class DeepLinkService {
  StreamSubscription? sub;
  final Ref ref;

  DeepLinkService(this.ref);

  void init() {
    getInitialUri().then(handleUri);
    sub = uriLinkStream.listen(handleUri);
  }

  Future<void> handleUri(Uri? uri) async {
    if (!isValidUri(uri)) return;

    debugPrint('[DeepLink] Handling URI: $uri');

    try {
      final authResult = await handleAuthUri(uri!);

      if (authResult.isSuccess) {
        await processSuccess(uri, authResult);
      } else {
        await processError(authResult.errorMessage.toString());
        debugPrint('[DeepLink] Auth failed: ${authResult.errorMessage}');
      }
    } on AuthException catch (e) {
      await processError(e.toString());
    }
  }

  /// Handle successful deep link auth
  Future<void> processSuccess(Uri uri, UnifiedAuthResult authResult) async {
    final supabase = Supabase.instance.client;
    final ctx = navigatorKey.currentContext;

    // Set session in Supabase
    await supabase.auth.setSession(authResult.session!.refreshToken.toString());

    // Clear expired link message
    ref.read(linkExpiredMessage.notifier).state = '';

    // Store login/reset state
    final metadata = authResult.session!.user.userMetadata;
    final isSocialLogin = isOAuth(metadata);
    final isResetPassword = uri.path.contains("reset-password");
    final isNewPassword = uri.path.contains("register-user");
    SharedPreferencesService.setUserLoggedIn(isSocialLogin);
    SharedPreferencesService.setResetPassword(isResetPassword);
    SharedPreferencesService.setNewPassword(isNewPassword);

    debugPrint('[DeepLink] User logged in: ${authResult.user?.email}');
    debugPrint('[DeepLink] Metadata: $metadata, isSocialLogin=$isSocialLogin, isResetPassword=$isResetPassword');

    // Handle navigation
    if (ctx != null && ctx.mounted) {
      if (uri.path.contains("reset-password")) {
        navigate(ctx, 'resetPassword');
      } else if (uri.path.contains("social-media-login")) {
        ref.invalidate(personalDataProvider);
        navigate(ctx, 'home');
      } else if (uri.path.contains('register-user')) {
        navigate(ctx, 'set-password');
      }
    }
  }

  /// Handle errors (expired/invalid link)
  Future<void> processError(String errorMessage) async {
    debugPrint('[DeepLink] Error: $errorMessage');

    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session != null) {
      // Recover state from existing session
      final metadata = session.user.userMetadata;
      final isSocialLogin = isOAuth(metadata);

      ref.read(linkExpiredMessage.notifier).state = '';
      SharedPreferencesService.setUserLoggedIn(isSocialLogin);
      SharedPreferencesService.setPhoneOTPAuthenticated(false);

      debugPrint('[DeepLink] Fallback: metadata=$metadata, isSocialLogin=$isSocialLogin');

      // Try refreshing session
      try {
        await supabase.auth.refreshSession();
      } catch (refreshError) {
        debugPrint('[DeepLink] Session refresh failed: $refreshError');
      }
    }

    // Show expired link message
    ref.read(linkExpiredMessage.notifier).state = errorMessage;

    // Redirect back to last route or login
    final ctx = navigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) {
      debugPrint('[DeepLink] Context not found in exception');
      return;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      final lastRoute = SharedPreferencesService.getLastRoute();
      debugPrint('[DeepLink] Redirecting from /callback → $lastRoute');

      if (lastRoute.isNotEmpty) {
        ctx.goNamed(lastRoute);
      } else {
        ctx.goNamed('login');
      }
    });
  }

  /// Navigate safely in microtask
  void navigate(BuildContext ctx, String routeName) {
    Future.microtask(() => ctx.goNamed(routeName));
  }

  /// Check if deep link is valid
  bool isValidUri(Uri? uri) {
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return path.contains('social-media-login') || path.contains('register-user') || path.contains('reset-password');
  }

  /// Detect if login was OAuth
  bool isOAuth(Map<String, dynamic>? metadata) {
    if (metadata == null) return false;
    final iss = metadata['iss']?.toString() ?? '';
    return iss.contains('google.com') || iss.contains('facebook.com') || iss.contains('twitter.com');
  }

  void dispose() => sub?.cancel();
}
