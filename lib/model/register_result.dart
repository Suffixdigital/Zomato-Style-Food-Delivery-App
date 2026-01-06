import 'package:smart_flutter/model/profile_check_result.dart';

class RegisterResult {
  final String email;

  final ProfileCheckResult? profileCheckResult;

  RegisterResult({required this.profileCheckResult, required this.email});

  // Helper factory for "not found"
  factory RegisterResult.notFound(String email) => RegisterResult(profileCheckResult: null, email: email);
}
