import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';

// final registerViewModelProvider = ChangeNotifierProvider(
//   (ref) => RegisterViewModel(),
// );

final registerViewModelProvider =
    AsyncNotifierProvider<RegisterViewModel, void>(RegisterViewModel.new);

class RegisterViewModel extends AsyncNotifier<void> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;

  @override
  Future<void> build() async {
    //_auth = FirebaseAuth.instance;
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String dob,
  }) async {
    state = const AsyncLoading();

    try {
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://suffixdigital.page.link/register',
        handleCodeInApp: true,
        androidPackageName: 'com.suffixdigital.smart_flutter',
        androidInstallApp: true,
        androidMinimumVersion: '21',
        dynamicLinkDomain: 'suffixdigital.page.link',
        iOSBundleId: 'com.suffixdigital.smartflutter.smartFlutter',
      );

      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);

      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e.message ?? 'An error occurred', StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> handleEmailLink(String link) async {
    state = const AsyncLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      if (email == null) throw Exception("No stored email");
      print("Email $email");

      if (!_auth.isSignInWithEmailLink(link)) {
        throw FirebaseAuthException(
          code: 'invalid-link',
          message: 'The link is invalid.',
        );
      }

      final userCredential = await _auth.signInWithEmailLink(
        email: email,
        emailLink: link,
      );

      ref.read(needsPasswordSetupProvider.notifier).state = true;
      state = AsyncData(userCredential.user);
      print("✅ Sign-in successful: ${userCredential.user?.email}");

    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      print("❌ Sign-in failed: $e");
    }
  }
}
