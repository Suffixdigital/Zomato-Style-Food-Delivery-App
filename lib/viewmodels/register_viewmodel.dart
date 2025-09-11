import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final registerViewModelProvider = AsyncNotifierProvider<RegisterViewModel, void>(RegisterViewModel.new);

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
  Future<void> registerUser({required String email, required String fullName, required String dob, required String gender, required String phoneNumber}) async {
    state = const AsyncLoading();
    try {
      // await SharedPreferencesService.setCachedEmail(email);
      // SharedPreferencesService.setUserLoggedIn(false);
      // SharedPreferencesService.setPhoneOTPAuthenticated(false);
      await Supabase.instance.client.auth.signOut();

      await supabase.auth.signUp(
        email: email,
        emailRedirectTo: 'io.supabase.flutterquickstart://callback/register-user',
        password: DeviceUtils.generateTempPassword(),
        data: {'full_name': fullName, 'dob': dob, 'gender': gender, 'phone': '91$phoneNumber', 'email': email, 'has_password': false},
      );

      print("Supabase user id: ${supabase.auth.currentUser?.id} email: ${supabase.auth.currentUser?.email}");
      state = const AsyncData(null); // Success
    } on AuthException catch (e) {
      if (e.message.contains('ERR_DUPLICATE_EMAIL')) {
        state = AsyncError(Exception('Auth error: This email is already registered.'), StackTrace.current);
      } else if (e.message.contains('ERR_DUPLICATE_PHONE')) {
        state = AsyncError(Exception('Auth error: This phone number is already registered.'), StackTrace.current);
      } else {
        state = AsyncError(Exception('Auth error: ${e.message}'), StackTrace.current);
      }
    } on SocketException catch (_) {
      state = AsyncError(Exception('No internet connection.'), StackTrace.current);
    } catch (e, stack) {
      state = AsyncError(Exception('Unexpected error: $e'), stack);
    }
  }

  Future<void> setUserPassword({required String password}) async {
    state = const AsyncLoading();
    try {
      await supabase.auth.updateUser(UserAttributes(password: password, data: {'has_password': true}));

      final userId = supabase.auth.currentUser!.id;
      await supabase.from('profiles').update({'has_password': true}).eq('id', userId);

      await supabase.auth.refreshSession();
      print("Supabase user id: ${supabase.auth.currentUser?.id} email: ${supabase.auth.currentUser?.email}");

      state = const AsyncData(null); // Success
    } on AuthException catch (e) {
      state = AsyncError(Exception('Auth error: ${e.message}'), StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError(Exception('No internet connection.'), StackTrace.current);
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
      state = AsyncError(Exception('Auth error: ${e.message}'), StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError(Exception('No internet connection.'), StackTrace.current);
    } catch (e, stack) {
      state = AsyncError(Exception('Unexpected error: $e'), stack);
    }
  }

  Future<void> phoneLogin({required String phoneNumber}) async {
    state = const AsyncLoading();
    try {
      await supabase.auth.signInWithOtp(phone: '+91$phoneNumber', shouldCreateUser: false, channel: OtpChannel.sms);

      state = const AsyncData(null); // Success
    } on AuthException catch (e) {
      state = AsyncError(Exception('Auth error: ${e.message}'), StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError(Exception('No internet connection.'), StackTrace.current);
    } catch (e, stack) {
      state = AsyncError(Exception('Unexpected error: $e'), stack);
    }
  }

  Future<void> phoneOTPVerification({required String phoneNumber, required String otp}) async {
    state = const AsyncLoading();
    try {
      await supabase.auth.verifyOTP(phone: '+91$phoneNumber', token: otp, type: OtpType.sms);

      await supabase.auth.refreshSession();

      state = const AsyncData(null); // Success
    } on AuthException catch (e) {
      state = AsyncError(Exception('Auth error: ${e.message}'), StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError(Exception('No internet connection.'), StackTrace.current);
    } catch (e, stack) {
      state = AsyncError(Exception('Unexpected error: $e'), stack);
    }
  }
}
