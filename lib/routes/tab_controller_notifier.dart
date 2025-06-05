import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

final persistentTabController = Provider<PersistentTabController>((ref) {
  final controller = PersistentTabController(initialIndex: 0);
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
