import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final needsPasswordSetupProvider = StateProvider<bool>((ref) => false);

final showResetPasswordSheetProvider = StateProvider<bool>((ref) => false);

final tabIndexProvider = StateProvider<int>((ref) => 0);
