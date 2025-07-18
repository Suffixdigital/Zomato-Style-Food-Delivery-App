import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// final registerViewModelProvider = ChangeNotifierProvider(
//   (ref) => RegisterViewModel(),
// );

final registerViewModelProvider =
    AsyncNotifierProvider<RegisterViewModel, void>(RegisterViewModel.new);

class RegisterViewModel extends AsyncNotifier<void> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;

  final supabase = Supabase.instance.client;

  @override
  Future<void> build() async {
    //_auth = FirebaseAuth.instance;
  }

  //Supabase based registration. email link verification
  Future<void> registerUser({
    required String email,
    required Map<String, dynamic> metadata,
  }) async {
    state = const AsyncLoading();
    try {
      // await SharedPreferencesService.setCachedEmail(email);
      SharedPreferencesService.setUserLoggedIn(false);
      Supabase.instance.client.auth.signOut(scope: SignOutScope.local);
      await supabase.auth.signInWithOtp(
        email: email,
        // emailRedirectTo: 'io.supabase.flutter://callback',
        emailRedirectTo: 'https://jpi.nub.mybluehostin.me/callback',
        data: metadata,
      );

      print(
        "Supabase user id: ${supabase.auth.currentUser?.id} email: ${supabase.auth.currentUser?.email}",
      );
      state = const AsyncData(null); // Success
    } on AuthException catch (e) {
      state = AsyncError(
        Exception('Auth error: ${e.message}'),
        StackTrace.current,
      );
    } on SocketException catch (_) {
      state = AsyncError(
        Exception('No internet connection.'),
        StackTrace.current,
      );
    } catch (e, stack) {
      state = AsyncError(Exception('Unexpected error: $e'), stack);
    }
  }

  Future<void> setUserPassword({required String password}) async {
    state = const AsyncLoading();
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: password, data: {'password_set': true}),
      );

      final userId = supabase.auth.currentUser!.id;
      await supabase
          .from('users')
          .update({'password': password, 'password_set': true})
          .eq('id', userId);

      await supabase.auth.refreshSession();
      print(
        "Supabase user id: ${supabase.auth.currentUser?.id} email: ${supabase.auth.currentUser?.email}",
      );

      state = const AsyncData(null); // Success
    } on AuthException catch (e) {
      state = AsyncError(
        Exception('Auth error: ${e.message}'),
        StackTrace.current,
      );
    } on SocketException catch (_) {
      state = AsyncError(
        Exception('No internet connection.'),
        StackTrace.current,
      );
    } catch (e, stack) {
      state = AsyncError(Exception('Unexpected error: $e'), stack);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);

      await supabase.auth.refreshSession();

      state = const AsyncData(null); // Success
    } on AuthException catch (e) {
      state = AsyncError(
        Exception('Auth error: ${e.message}'),
        StackTrace.current,
      );
    } on SocketException catch (_) {
      state = AsyncError(
        Exception('No internet connection.'),
        StackTrace.current,
      );
    } catch (e, stack) {
      state = AsyncError(Exception('Unexpected error: $e'), stack);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    try {
      // ✅ Check if user exists and is NOT a social login
      final response =
          await supabase
              .from(
                'users',
              ) // your public users table (optional if using RLS properly)
              .select('provider')
              .eq('email', email)
              .maybeSingle();

      final provider = response?['provider'];

      if (provider != null && provider != 'email') {
        state = AsyncError(
          Exception(
            'This account uses ${provider.toUpperCase()} login. Please sign in with that provider.',
          ),
          StackTrace.current,
        );
      }

      final redirectUrl =
          'https://jpi.nub.mybluehostin.me/callback'; // ✅ Must match Supabase auth settings

      await supabase.auth.resetPasswordForEmail(email, redirectTo: redirectUrl);

      state = const AsyncData(null); // Success
      debugPrint('Reset link sent successfully to $email');
    } on AuthException catch (e) {
      state = AsyncError(
        Exception('Auth error: ${e.message}'),
        StackTrace.current,
      );
    } on SocketException catch (_) {
      state = AsyncError(
        Exception('No internet connection.'),
        StackTrace.current,
      );
    } catch (e, stack) {
      state = AsyncError(Exception('Unexpected error: $e'), stack);
    }
  }
}
