class ProfileCheckResult {
  final String? email;
  final String? phone;
  final bool? hasPassword;
  final String? message;

  ProfileCheckResult({required this.email, required this.phone, required this.hasPassword, required this.message});

  factory ProfileCheckResult.fromJson(Map<String, dynamic> json) {
    return ProfileCheckResult(email: json['email'], phone: json['phone'], hasPassword: json['has_password'], message: json['message']);
  }
}
