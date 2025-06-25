import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/viewmodels/register_viewmodel.dart';
import 'package:uni_links/uni_links.dart';

final deepLinkServiceProvider = Provider((ref) => DeepLinkService(ref));

class DeepLinkService {
  final Ref ref;
  StreamSubscription? _sub;

  DeepLinkService(this.ref);

  String? lastHandledLink;

  void init() {
    startService();
  }

  dispose() {
    _sub?.cancel();
  }

  void startService() async {
    // Get the initial link (cold start)
    final initialUri = await getInitialUri();
    if (initialUri != null) {
      print("Initial Firebase email link: $initialUri");
      handleLink(initialUri.toString());
    }

    // Handle foreground dynamic links
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print("Real-time Firebase email link: $uri");
        handleLink(uri.toString());
      }
    });
  }

  void handleLink(String link) {
    ref.watch(registerViewModelProvider.notifier).handleEmailLink(link);
  }
}
