import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/model/profile_check_result.dart';
import 'package:smart_flutter/routes/app_routes.dart';

class ProfileResultDialog {
  static void show(BuildContext context, ProfileCheckResult profileResult) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) {
      return;
    }
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder:
          (_) => AlertDialog(
            title: Text(profileResult.hasPassword! ? 'Account Found' : 'Set Your Password'),
            content: Text(
              profileResult.hasPassword!
                  ? 'An account with this email already exists. Please log in.'
                  : ''
                      'This account exists but no password is set yet. Please set your password.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  profileResult.hasPassword! ? ctx.goNamed('login') : ctx.goNamed('set-password', extra: null);
                },
                child: Text(profileResult.hasPassword! ? 'Go To Login' : 'Go To Set Password'),
              ),
            ],
          ),
    );
  }
}
