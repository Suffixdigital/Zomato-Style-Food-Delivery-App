import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/api_clients/api_provider.dart';
import 'package:smart_flutter/model/email_phone_link_request.dart';
import 'package:smart_flutter/model/email_phone_link_response.dart';
import 'package:smart_flutter/providers/dio_provider.dart';

final emailPhoneLinkProvider = AsyncNotifierProvider<EmailPhoneLinkNotifier, EmailPhoneLinkResponse?>(EmailPhoneLinkNotifier.new);

class EmailPhoneLinkNotifier extends AsyncNotifier<EmailPhoneLinkResponse?> {
  late final ApiProvider apiProvider;

  @override
  FutureOr<EmailPhoneLinkResponse?> build() {
    apiProvider = ApiProvider(ref.read(dioProvider));
    return null;
  }

  Future<void> emailPhoneLink(EmailPhoneLinkRequest request) async {
    state = const AsyncLoading();
    try {
      final result = await apiProvider.emailPhoneLink(request);
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(Exception('Failed to link email and phone. ${e.toString()}'), st);
    }
  }
}
