import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/routes/app_routes.dart';

class LinkExpiredDialog {
  static void show(BuildContext context, String message) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) {
      return;
    }
    print("[Deeplink] exception message: ${message.contains("code verifier")} || ${message.contains("expired")}  || ${message.contains('invalid flow state')}");
    if (message.contains("code verifier") || message.contains("expired") || message.contains('invalid flow state')) {
      showDialog(
        context: ctx,
        barrierDismissible: true,
        builder:
            (_) => AlertDialog(
              title: const Text('Link Expired'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    ctx.pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }
}
