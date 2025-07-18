class EmailValidationResponse {
  final bool isEmailLinkUser;
  final String? error;

  EmailValidationResponse({required this.isEmailLinkUser, this.error});

  factory EmailValidationResponse.fromJson(Map<String, dynamic> json) {
    return EmailValidationResponse(
      isEmailLinkUser: json['isEmailLinkUser'] ?? false,
      error: json['error'],
    );
  }
}
