import 'package:supabase_flutter/supabase_flutter.dart';

/// Normalized result for both SDKs
class UnifiedAuthResult {
  final Session? session;
  final User? user;
  final String? errorMessage;

  UnifiedAuthResult({this.session, this.user, this.errorMessage});

  bool get isSuccess => session != null && user != null;
}

Future<UnifiedAuthResult> handleAuthUri(Uri uri) async {
  try {
    // Case: Reset password link
    if (uri.path.contains('reset-password')) {
      final code = uri.queryParameters['code'];

      if (code == null) {
        return UnifiedAuthResult(errorMessage: 'Email link is invalid or has expired, statusCode: otp_expired, code: access_denied');
      }
      // final email = uri.queryParameters['email'];

      // Exchange code for session (user must now set new password)
      final response = await Supabase.instance.client.auth.exchangeCodeForSession(code);
      // final response = await Supabase.instance.client.auth.verifyOTP(email: email, type: OtpType.recovery, token: code);

      return UnifiedAuthResult(session: response.session, user: response.user, errorMessage: null);
    }

    // Case: Social login / email confirmation / magic link
    final response = await Supabase.instance.client.auth.getSessionFromUrl(uri);

    if (response is AuthResponse) {
      return UnifiedAuthResult(session: response.session, user: response.user, errorMessage: response.error?.message);
    }

    if (response is AuthSessionUrlResponse) {
      return UnifiedAuthResult(session: response.session, user: response.user, errorMessage: response.error?.message);
    }

    return UnifiedAuthResult(errorMessage: 'Unsupported Supabase response type');
  } on AuthException catch (e) {
    return UnifiedAuthResult(errorMessage: e.message);
  } catch (e) {
    return UnifiedAuthResult(errorMessage: e.toString());
  }
}

extension AuthSessionUrlResponseX on AuthSessionUrlResponse {
  /// Mimic old `.user`
  User? get user => session?.user;

  /// Mimic old `.error`
  AuthException? get error {
    if (session == null) {
      return AuthException('No session found (maybe expired or invalid link)');
    }
    return null;
  }
}
