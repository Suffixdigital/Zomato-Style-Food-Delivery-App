import 'package:flutter/material.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';

class RouteTrackingObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    saveCurrentRoute(route.settings.name);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    saveCurrentRoute(newRoute?.settings.name);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    saveCurrentRoute(previousRoute?.settings.name);
  }

  void saveCurrentRoute(String? routeName) async {
    if (routeName == null || routeName.contains('register-user') || routeName.contains('reset-password')) {
      return;
    }
    SharedPreferencesService.saveLastRoute(routeName);
    debugPrint('Saved current route: $routeName');
  }
}
