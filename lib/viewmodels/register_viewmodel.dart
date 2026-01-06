import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/model/register_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final registerViewModelProvider = AsyncNotifierProvider<RegisterViewModel, RegisterResult?>(RegisterViewModel.new);

class RegisterViewModel extends AsyncNotifier<RegisterResult?> {
  bool isLoading = false;
  String? errorMessage;

  final supabase = Supabase.instance.client;

  @override
  FutureOr<RegisterResult?> build() => null;

  //Supabase based registration. email link verification
  /*Future<void> registerUser({required String email, required String fullName, required String dob, required String gender, required String phoneNumber}) async {
    state = const AsyncLoading();
    try {
      // await SharedPreferencesService.setCachedEmail(email);
      // SharedPreferencesService.setUserLoggedIn(false);
      // SharedPreferencesService.setPhoneOTPAuthenticated(false);

      // Normalize email to lowercase before checking
      final normalizedEmail = email.trim().toLowerCase();

      // Step 1: Check if profile exists via RPC
      final response = await supabase.rpc('check_profile_by_email', params: {'input_email': normalizedEmail});

      final data = response as Map<String, dynamic>;

      final result = ProfileCheckResult.fromJson(data);

      final profileExists = result.message != 'user not found';
      final hasPassword = result.hasPassword == true;
      final hasPhoneNumber = result.phone != null;

      print('ProfileCheckResult: ${result.toString()} profileExists: $profileExists, hasPassword: $hasPassword, hasPhoneNumber: $hasPhoneNumber');

      if (profileExists) {
        if (!hasPhoneNumber && !hasPassword) {
          await Supabase.instance.client.auth.signOut();

          //User already registered with social login and needs to set email provider and phone provider.
          state = AsyncData(RegisterResult(profileCheckResult: result, email: email));
        } else {
          state = AsyncData(RegisterResult(profileCheckResult: result, email: email));
        }
        return;
      } else {
        await Supabase.instance.client.auth.signOut();
        // New user
        print('new user register process and email link sent.');
        await supabase.auth.signUp(
          email: email,
          emailRedirectTo: 'io.supabase.flutterquickstart://callback/register-user',
          password: DeviceUtils.generateTempPassword(),
          data: {'full_name': fullName, 'dob': dob, 'gender': gender, 'phone': '91$phoneNumber', 'email': email, 'has_password': false},
        );

        state = AsyncData(RegisterResult(profileCheckResult: result, email: email));
      }
      // Success
    } on AuthException catch (e) {
      if (e.message.contains('ERR_DUPLICATE_EMAIL')) {
        state = AsyncError('Auth error: This email is already registered.', StackTrace.current);
      } else if (e.message.contains('ERR_DUPLICATE_PHONE')) {
        state = AsyncError('Auth error: This phone number is already registered.', StackTrace.current);
      } else {
        state = AsyncError('Auth error: ${e.message}', StackTrace.current);
      }
    } on SocketException catch (_) {
      state = AsyncError('Error: No internet connection.', StackTrace.current);
    } catch (e, stack) {
      print('Unexpected error: $e');
      state = AsyncError('Unexpected error: $e', stack);
    }
  }*/

  //Supabase based registration. email link verification
  Future<void> registerUser({required String email, required String fullName, required String dob, required String gender, required String phoneNumber}) async {
    state = const AsyncLoading();
    try {
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
      state = AsyncError('Auth error: ${e.message}', StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError('Error: No internet connection.', StackTrace.current);
    } catch (e, stack) {
      state = AsyncError('Unexpected error: $e', stack);
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

      state = AsyncData(RegisterResult(profileCheckResult: null, email: '')); // Success
    } on AuthException catch (e) {
      state = AsyncError('Auth error: ${e.message}', StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError('Error: No internet connection.', StackTrace.current);
    } catch (e, stack) {
      state = AsyncError('Unexpected error: $e', stack);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);

      await supabase.auth.refreshSession();

      state = AsyncData(RegisterResult(profileCheckResult: null, email: '')); // Success
    } on AuthException catch (e) {
      state = AsyncError('Auth error: ${e.message}', StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError('Error: No internet connection.', StackTrace.current);
    } catch (e, stack) {
      state = AsyncError('Unexpected error: $e', stack);
    }
  }

  Future<void> phoneLogin({required String phoneNumber}) async {
    state = const AsyncLoading();
    try {
      await supabase.auth.signInWithOtp(phone: '+91$phoneNumber', shouldCreateUser: false, channel: OtpChannel.sms);

      state = AsyncData(RegisterResult(profileCheckResult: null, email: '')); // Success
    } on AuthException catch (e) {
      state = AsyncError('Auth error: ${e.message}', StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError('Error: No internet connection.', StackTrace.current);
    } catch (e, stack) {
      state = AsyncError('Unexpected error: $e', stack);
    }
  }

  Future<void> phoneOTPVerification({required String phoneNumber, required String otp}) async {
    state = const AsyncLoading();
    try {
      await supabase.auth.verifyOTP(phone: '+91$phoneNumber', token: otp, type: OtpType.sms);

      await supabase.auth.refreshSession();

      state = AsyncData(RegisterResult(profileCheckResult: null, email: '')); // Success
    } on AuthException catch (e) {
      state = AsyncError('Auth error: ${e.message}', StackTrace.current);
    } on SocketException catch (_) {
      state = AsyncError('Error: No internet connection.', StackTrace.current);
    } catch (e, stack) {
      state = AsyncError('Unexpected error: $e', stack);
    }
  }
}
