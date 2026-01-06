import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/api_clients/api_provider.dart';
import 'package:smart_flutter/model/email_request.dart';
import 'package:smart_flutter/model/email_response.dart';
import 'package:smart_flutter/providers/dio_provider.dart';
// Your Dio setup

final emailValidationProvider = AsyncNotifierProvider<EmailValidationNotifier, EmailValidationResponse?>(EmailValidationNotifier.new);

class EmailValidationNotifier extends AsyncNotifier<EmailValidationResponse?> {
  late final ApiProvider apiProvider;

  @override
  FutureOr<EmailValidationResponse?> build() {
    apiProvider = ApiProvider(ref.read(dioProvider));
    return null;
  }

  Future<void> validate(String email) async {
    state = const AsyncLoading();
    try {
      final result = await apiProvider.validateEmail(EmailValidationRequest(email: email));
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(Exception('Failed to validate email.'), st);
    }
  }
}
