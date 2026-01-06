class EmailPhoneLinkResponse {
  final String? error;
  final String? message;

  EmailPhoneLinkResponse({this.error, this.message});

  factory EmailPhoneLinkResponse.fromJson(Map<String, dynamic> json) {
    return EmailPhoneLinkResponse(message: json['message'], error: json['error']);
  }
}
