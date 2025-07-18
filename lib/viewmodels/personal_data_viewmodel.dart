import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_flutter/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalDataViewModel extends AsyncNotifier<UserModel> {
  @override
  Future<UserModel> build() async {
    return getCurrentUserProfile();
  }

  UserModel _user = UserModel(
    fullName: "Kirtikant Patadiya",
    dateOfBirth: DateFormat('dd/MM/yyyy').format(DateTime(1991, 5, 17)),
    gender: "Male",
    phone: "8866121457",
    email: "kirtikantpatadiya@gmail.com",
    provider: "",
  );

  UserModel get user => _user;

  Future<UserModel> getCurrentUserProfile() async {
    final userData = UserModel(
      fullName: "",
      dateOfBirth: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      gender: "",
      phone: "",
      email: "",
      provider: "",
    );

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return userData;
    }

    final data =
        await supabase
            .from('users') // your custom table
            .select()
            .eq('id', user.id)
            .single();

    return UserModel(
      fullName: data['name'] ?? '',
      dateOfBirth: data['dob'] ?? '',
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      provider: data['provider'] ?? '',
    );
  }

  Future<void> updateUser(UserModel updatedUser) async {
    // state = const AsyncLoading();
    final supabase = Supabase.instance.client;
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase
          .from('users')
          .update({
            'email': updatedUser.email,
            'name': updatedUser.fullName,
            'dob': updatedUser.dateOfBirth,
            'gender': updatedUser.gender.toLowerCase(),
            'phone': updatedUser.phone,
          })
          .eq('id', userId);

      await supabase.auth.refreshSession();
      print(
        "Supabase user id: ${supabase.auth.currentUser?.id} email: ${supabase.auth.currentUser?.email}",
      );

      state = AsyncData(updatedUser); // Success
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

    //notifyListeners();
  }
}

/*final personalDataProvider = ChangeNotifierProvider(
  (ref) => PersonalDataViewModel(),
);*/

final personalDataProvider =
    AsyncNotifierProvider<PersonalDataViewModel, UserModel>(
      () => PersonalDataViewModel(),
    );
