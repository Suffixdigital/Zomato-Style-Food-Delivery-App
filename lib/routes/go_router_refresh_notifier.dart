import 'dart:async';

import 'package:flutter/foundation.dart';

/*final goRouterRefreshNotifierProvider = Provider<GoRouterRefreshNotifier>((
  ref,
) {
  final authStream = ref.watch(authStateProvider.notifier).stream;
  return GoRouterRefreshNotifier(authStream);
});*/

/// A `ChangeNotifier` that listens to a stream and notifies GoRouter to rebuild.
class GoRouterRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshNotifier(Stream<dynamic> stream) {
    // Trigger initial build
    notifyListeners();

    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
