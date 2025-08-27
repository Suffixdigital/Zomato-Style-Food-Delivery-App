import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfirmationDialog {
  static Future<void> signOutUser() async {
    await Supabase.instance.client.auth.signOut();
    SharedPreferencesService.setResetPassword(false);
    SharedPreferencesService.setNewPassword(false);
  }

  static void show(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  signOutUser();
                  context.goNamed('login');
                  context.pop();
                },
                child: Text('Yes'),
              ),
            ],
          ),
    );
  }
}
