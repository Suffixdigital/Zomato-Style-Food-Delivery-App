class EmailValidationRequest {
  final String email;

  EmailValidationRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}
