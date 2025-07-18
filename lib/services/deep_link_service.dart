import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/routes/app_routes.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links/uni_links.dart';

import '../viewmodels/personal_data_viewmodel.dart';

final deepLinkServiceProvider = Provider((ref) => DeepLinkService(ref));

class DeepLinkService {
  StreamSubscription? _sub;
  final Ref ref;

  DeepLinkService(this.ref);

  void init() {
    getInitialUri().then(_handleUri);
    _sub = uriLinkStream.listen(_handleUri);
  }

  Future<void> _handleUri(Uri? uri) async {
    final supabase = Supabase.instance.client;

    if (uri == null ||
        !(uri.path.contains('callback') ||
            uri.path.contains('reset-password'))) {
      return;
    }

    debugPrint('[DeepLink] Processing: $uri');
    final uriStr = uri.toString();
    try {
      final response = await Supabase.instance.client.auth.getSessionFromUrl(
        uri,
      );
      final session = response.session;
      if (session.refreshToken != null) {
        await supabase.auth.setSession(session.refreshToken!);
        ref.watch(linkExpiredMessage.notifier).state = '';

        final ctx = navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          final metadata = session.user.userMetadata;
          final isSocialLogin = isOAuth(metadata);
          final isPasswordSet = metadata?['password_set'] == true;
          final isResetPassword = uriStr.contains('reset-password');
          SharedPreferencesService.setResetPassword(isResetPassword);
          SharedPreferencesService.setUserLoggedIn(isSocialLogin);

          if (isSocialLogin) {
            ref.invalidate(personalDataProvider);
          }

          debugPrint(
            '[DeepLink] Try block: metadata: $metadata  isSocialLogin: $isSocialLogin isPasswordSet: $isPasswordSet',
          );

          Future.microtask(() {
            ctx.goNamed(
              isResetPassword
                  ? 'resetPassword'
                  : isSocialLogin
                  ? 'home'
                  : (isPasswordSet ? 'home' : 'set-password'),
            );
          });
        }
      } else {
        debugPrint('[DeepLink] No refresh token in session');
      }
    } catch (e) {
      debugPrint('[DeepLink] Error: $e');

      final session = supabase.auth.currentSession;

      if (session != null) {
        final ctx = navigatorKey.currentContext;
        final metadata = session.user.userMetadata;
        final isSocialLogin = isOAuth(metadata);
        final isPasswordSet = metadata?['password_set'] == true;

        if (ctx != null && ctx.mounted) {
          ref.watch(linkExpiredMessage.notifier).state = ''; // Clear error

          SharedPreferencesService.setUserLoggedIn(isSocialLogin);

          debugPrint(
            '[DeepLink] Catch block: metadata: $metadata  isSocialLogin: $isSocialLogin isPasswordSet: $isPasswordSet',
          );
        }
      }

      // Session is null → fallback to login
      if (session != null) {
        try {
          await supabase.auth.refreshSession();
        } catch (refreshError) {
          debugPrint('[DeepLink] Session refresh failed: $refreshError');
        }
      }

      ref.watch(linkExpiredMessage.notifier).state = e.toString();

      final ctx = navigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) {
        debugPrint('[DeepLink] Context not found in exception');
        return;
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        final lastRoute = SharedPreferencesService.getLastRoute();
        debugPrint('Redirecting from /callback to lastRoute: $lastRoute');

        // Use pushReplacementNamed to cleanly replace /callback
        if (lastRoute.isNotEmpty) {
          ctx.goNamed(lastRoute);
        } else {
          ctx.goNamed('login');
        }
      });
    }
  }

  bool isOAuth(Map<String, dynamic>? metadata) {
    if (metadata == null) return false;

    final iss = metadata['iss']?.toString() ?? '';
    return iss.contains('google.com') ||
        iss.contains('facebook.com') ||
        iss.contains('twitter.com');
  }

  void dispose() => _sub?.cancel();
}
